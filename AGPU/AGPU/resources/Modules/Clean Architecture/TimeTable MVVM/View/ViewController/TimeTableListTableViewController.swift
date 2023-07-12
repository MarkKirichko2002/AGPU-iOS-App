//
//  TimeTableListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

class TimeTableListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let service = TimeTableService()
    private let dateManager = DateManager()
    private var timetable = [TimeTable]()
    private var group = ""
    
    // MARK: - UI
    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let noTimeTableLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        SetUpIndicatorView()
        SetUpLabel()
        GetTimeTable(date: "06.06.2023", group: UserDefaults.standard.object(forKey: "group") as? String ?? "")
        ObserveCalendar()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Расписание"
        let groups = AGPUGroups.groups
            .map { group in
                return UIAction(title: group) { _ in
                    DispatchQueue.main.async {
                        self.group = group
                        self.spinner.startAnimating()
                        self.noTimeTableLabel.isHidden = true
                        self.timetable = []
                        self.tableView.reloadData()
                        self.GetTimeTable(date: "06.06.2023", group: group)
                    }
                }
            }
        let groupList = UIMenu(title: "группы", children: groups)
        let calendar = UIBarButtonItem(image: UIImage(named: "calendar"), style: .plain, target: self, action: #selector(openCalendar))
        let list = UIBarButtonItem(image: UIImage(named: "sections"), menu: groupList)
        list.tintColor = .black
        calendar.tintColor = .black
        navigationItem.rightBarButtonItems = [calendar, list]
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
    
    func GetTimeTable(date: String, group: String) {
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
                    self.GetTimeTable(date: date, group: self.group)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableTableViewCell.identifier, for: indexPath) as? TimeTableTableViewCell else {return UITableViewCell()}
        
        cell.configure(timetable: timetable[indexPath.row])
        
        return cell
    }
}
