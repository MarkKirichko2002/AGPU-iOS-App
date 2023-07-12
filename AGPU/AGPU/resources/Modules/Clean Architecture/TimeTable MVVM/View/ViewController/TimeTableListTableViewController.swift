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
        GetTimeTable(date: "06.06.2023")
        ObserveCalendar()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Расписание"
        let next = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .plain, target: self, action: nil)
        let previous = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: nil)
        let calendar = UIBarButtonItem(image: UIImage(named: "calendar"), style: .plain, target: self, action: #selector(openCalendar))
        next.tintColor = .black
        previous.tintColor = .black
        calendar.tintColor = .black
        navigationItem.rightBarButtonItems = [next, previous, calendar]
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
    
    func GetTimeTable(date: String) {
        service.GetTimeTable(groupId: "ВМ-ИВТ-1-1", date: date) { timetable in
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
                    self.GetTimeTable(date: date)
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
