//
//  TimeTableDayListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

final class TimeTableDayListTableViewController: UIViewController {
    
    private var group = ""
    private var subgroup = 0
    private var date = ""
    
    var timetable: TimeTable?
    
    // MARK: - сервисы
    private let service = TimeTableService()
    private let dateManager = DateManager()
    
    // MARK: - UI
    let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let noTimeTableLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpData()
        SetUpNavigation()
        SetUpTable()
        SetUpRefreshControl()
        SetUpIndicatorView()
        SetUpLabel()
        GetTimeTable(group: group, date: date)
        ObserveGroupChange()
        ObserveSubGroupChange()
        ObserveCalendar()
    }
    
    private func SetUpData() {
        self.group = UserDefaults.standard.string(forKey: "group") ?? ""
        self.subgroup = UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
        date = dateManager.getCurrentDate()
    }
    
    private func SetUpNavigation() {
        
        navigationItem.title = "Сегодня: \(date)"
        
        // список групп
        let groupList = UIAction(title: "группы") { _ in
            let vc = AllGroupsListTableViewController(group: self.group)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // сегодняшний день
        let current = UIAction(title: "сегодня") { _ in
            let currentDay = self.dateManager.getCurrentDate()
            self.GetTimeTable(group: self.group, date: currentDay)
            self.date = currentDay
            self.navigationItem.title = self.date
        }
        // следующий день
        let next = UIAction(title: "завтра") { _ in
            let nextDay = self.dateManager.nextDay(date: self.date)
            self.GetTimeTable(group: self.group, date: nextDay)
            self.date = nextDay
            self.navigationItem.title = self.date
        }
        // предыдущий день
        let previous = UIAction(title: "вчера") { _ in
            let previousDay = self.dateManager.previousDay(date: self.date)
            self.GetTimeTable(group: self.group, date: previousDay)
            self.date = previousDay
            self.navigationItem.title = self.date
        }
        // календарь
        let calendar = UIAction(title: "календарь") { _ in
            let vc = CalendarViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        // день
        let day = UIMenu(title: "выбрать день", children: [
            current,
            next,
            previous,
            calendar
        ])
        
        
        let weeksList = UIAction(title: "список недель") { _ in
            let vc = AllWeeksListTableViewController(group: self.group, subgroup: self.subgroup)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // поделиться
        let shareTimeTable = UIAction(title: "поделиться") { _ in
            self.shareTableViewAsImage(tableView: self.tableView, title: self.date, text: self.group)
        }
        
        let menu = UIMenu(title: "расписание", children: [
            groupList,
            day,
            weeksList,
            shareTimeTable
        ])
        
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        options.tintColor = .black
        self.navigationItem.rightBarButtonItem = options
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
    
    private func SetUpRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTimetable), for: .valueChanged)
    }
    
    @objc private func refreshTimetable() {
        GetTimeTable(group: group, date: date)
    }
    
    private func SetUpLabel() {
        view.addSubview(noTimeTableLabel)
        noTimeTableLabel.text = "Нет расписания"
        noTimeTableLabel.font = .systemFont(ofSize: 18, weight: .medium)
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
        self.timetable?.disciplines = []
        self.tableView.reloadData()
        service.GetTimeTableDay(groupId: group, date: date) { result in
            switch result {
            case .success(let timetable):
                if !timetable.disciplines.isEmpty {
                    DispatchQueue.main.async {
                        let data = timetable.disciplines.filter { $0.subgroup == self.subgroup || $0.subgroup == 0 || (self.subgroup == 0 && ($0.subgroup == 1 || $0.subgroup == 2)) }
                        self.timetable = timetable
                        self.timetable?.disciplines = data
                        self.tableView.reloadData()
                        self.spinner.stopAnimating()
                        self.refreshControl.endRefreshing()
                        self.noTimeTableLabel.isHidden = true
                    }
                } else {
                    self.spinner.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.noTimeTableLabel.isHidden = false
                }
            case .failure(let error):
                self.spinner.stopAnimating()
                self.refreshControl.endRefreshing()
                self.noTimeTableLabel.text = "Ошибка"
                self.noTimeTableLabel.isHidden = false
                print(error.localizedDescription)
            }
        }
    }
    
    private func ObserveGroupChange() {
        NotificationCenter.default.addObserver(forName: Notification.Name("group changed"), object: nil, queue: .main) { notification in
            let group = notification.object as? String ?? ""
            self.GetTimeTable(group: group, date: self.date)
            self.group = group
            print(self.group)
        }
    }
    
    private func ObserveSubGroupChange() {
        NotificationCenter.default.addObserver(forName: Notification.Name("subgroup changed"), object: nil, queue: .main) { _ in
            self.subgroup = UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
            self.GetTimeTable(group: self.group, date: self.date)
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
