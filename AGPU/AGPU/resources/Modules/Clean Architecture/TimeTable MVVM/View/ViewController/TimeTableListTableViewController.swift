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
    private var group = ""
    
    // MARK: - UI
    let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let noTimeTableLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        SetUpIndicatorView()
        SetUpLabel()
        GetTimeTable(group: "ВМ-ИВТ-2-1", date: dateManager.getCurrentDate())
        ObserveCalendar()
    }
    
    private func SetUpNavigation() {
        var arr = [UIAction]()
        navigationItem.title = "Расписание"
        service.GetAllGroups { groups in
            for (key,value) in groups {
                let items = value.map { group in
                    return UIAction(title: group) { _ in
                        DispatchQueue.main.async {
                            self.group = group
                            self.spinner.startAnimating()
                            self.noTimeTableLabel.isHidden = true
                            self.timetable = []
                            self.tableView.reloadData()
                            self.GetTimeTable(group: self.group, date: self.dateManager.getCurrentDate())
                        }
                    }
                }
                arr.append(contentsOf: items)
                let groupList = UIMenu(title: "группы", children: arr)
                let calendar = UIBarButtonItem(image: UIImage(named: "calendar"), style: .plain, target: self, action: #selector(self.openCalendar))
                let list = UIBarButtonItem(image: UIImage(named: "sections"), menu: groupList)
                list.tintColor = .black
                calendar.tintColor = .black
                self.navigationItem.rightBarButtonItems = [calendar, list]
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
    
    @objc private func openCalendar() {
        let vc = CalendarViewController()
        present(vc, animated: true)
    }
    
    private func ObserveCalendar() {
        NotificationCenter.default.addObserver(forName: Notification.Name("DateWasSelected"), object: nil, queue: .main) { notification in
            if let date = notification.object as? String {
                DispatchQueue.main.async {
                    self.spinner.startAnimating()
                    self.noTimeTableLabel.isHidden = true
                    self.timetable = []
                    self.tableView.reloadData()
                    self.GetTimeTable(group: date, date: self.group)
                }
            }
        }
    }
    
    private func SetUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeTableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableTableViewCell.identifier)
    }
}
