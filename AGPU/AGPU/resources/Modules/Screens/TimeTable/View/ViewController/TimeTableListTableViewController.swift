//
//  TimeTableListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

class TimeTableListTableViewController: UIViewController {
    
    private let service = TimeTableService()
    private let dateManager = DateManager()
    var timetable = [TimeTable]()
    private var group = UserDefaults.standard.string(forKey: "group") ?? "ВМ-ИВТ-1-1"
    private var date = ""
    
    // MARK: - UI
    let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let noTimeTableLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date = dateManager.getCurrentDate()
        SetUpNavigation()
        SetUpTable()
        SetUpIndicatorView()
        SetUpLabel()
        ObserveCalendar()
        GetTimeTable(group: group, date: dateManager.getCurrentDate())
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Расписание"
        
        service.GetAllGroups { groups in
            DispatchQueue.main.async { // Выполнение кода в основном потоке
                var arr = [UIMenu]()
                for (key, value) in groups {
                    let items = value.map { group in
                        return UIAction(title: group) { [weak self] _ in
                            guard let self = self else { return }
                            self.group = group
                            self.spinner.startAnimating()
                            self.noTimeTableLabel.isHidden = true
                            self.timetable = []
                            self.tableView.reloadData()
                            self.GetTimeTable(group: group, date: date)
                        }
                    }
                    
                    let mainMenu = UIMenu(title: key.abbreviation(), children: items)
                    arr.append(mainMenu)
                }
                let groupList = UIMenu(title: "группы", image: UIImage(named: "group"), children: arr)
                let calendar = UIAction(title: "календарь", image: UIImage(named: "calendar")) { _ in
                    let vc = CalendarViewController()
                    self.present(vc, animated: true)
                }
                let shareTimeTable = UIAction(title: "поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    self.shareTableViewAsImage(tableView: self.tableView, title: self.date, text: self.group)
                }
                let optionsMenu = UIMenu(title: "расписание", children: [calendar, groupList, shareTimeTable])
                let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: optionsMenu)
                options.tintColor = .black
                self.navigationItem.rightBarButtonItem = options
            }
        }
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Расписание"
        
        var arr = [UIMenu]()
        
        service.GetAllGroups { groups in
            for (key, value) in groups {
                let items = value.map { group in
                    return UIAction(title: group) { [weak self] _ in
                        guard let self = self else { return }
                        self.group = group
                        self.spinner.startAnimating()
                        self.noTimeTableLabel.isHidden = true
                        self.timetable = []
                        self.tableView.reloadData()
                        self.GetTimeTable(group: group, date: date)
                    }
                }
                
                let mainMenu = UIMenu(title: key.abbreviation(), children: items)
                arr.append(mainMenu)
            }
            
            let groupsList = UIMenu(title: "группы", image: UIImage(named: "group"), children: arr)
            
            DispatchQueue.main.async {
                let calendar = UIAction(title: "календарь", image: UIImage(named: "calendar")) { _ in
                    let vc = CalendarViewController()
                    self.present(vc, animated: true)
                }
                let shareTimeTable = UIAction(title: "поделиться", image: UIImage(named: "share")) { _ in
                    self.shareTableViewAsImage(tableView: self.tableView, title: self.date, text: self.group)
                }
                let optionsMenu = UIMenu(title: "расписание", children: [groupsList, calendar, shareTimeTable])
                let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: optionsMenu)
                options.tintColor = .black
                self.navigationItem.rightBarButtonItem = options
            }
        }
    }
    
    
    private func SetUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.startAnimating()
    }
    
    private func SetUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeTableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func SetUpLabel() {
        view.addSubview(noTimeTableLabel)
        noTimeTableLabel.text = "Нет расписания"
        noTimeTableLabel.isHidden = true
        noTimeTableLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noTimeTableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTimeTableLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func GetTimeTable(group: String, date: String) {
        self.spinner.startAnimating()
        self.noTimeTableLabel.isHidden = true
        self.timetable = []
        self.tableView.reloadData()
        service.GetTimeTable(groupId: group, date: date) { timetable in
            if !timetable.isEmpty {
                DispatchQueue.main.async {
                    self.timetable = timetable
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    self.noTimeTableLabel.isHidden = true
                }
            } else {
                self.noTimeTableLabel.isHidden = false
                self.spinner.stopAnimating()
            }
        }
    }
    
    private func ObserveCalendar() {
        NotificationCenter.default.addObserver(forName: Notification.Name("DateWasSelected"), object: nil, queue: .main) { notification in
            if let date = notification.object as? String {
                self.date = date
                self.GetTimeTable(group: self.group, date: date)
                self.navigationItem.title = date
            }
        }
    }
}

