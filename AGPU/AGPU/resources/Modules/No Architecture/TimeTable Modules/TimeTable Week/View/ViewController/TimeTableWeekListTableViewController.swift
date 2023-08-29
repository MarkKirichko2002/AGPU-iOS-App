//
//  TimeTableWeekListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.08.2023.
//

import UIKit

final class TimeTableWeekListTableViewController: UIViewController {
    
    private var group: String = ""
    private var subgroup: Int = 0
    var week: WeekModel!
    var timetable = [TimeTable]()
    
    // MARK: - сервисы
    private let service = TimeTableService()
    private let dateManager = DateManager()
    
    // MARK: - UI
    let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let noTimeTableLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init
    init(group: String, subgroup: Int, week: WeekModel) {
        self.group = group
        self.subgroup = subgroup
        self.week = week
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpTable()
        SetUpLabel()
        SetUpIndicatorView()
        GetTimeTable()
        SetUpRefreshControl()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.ScrollToCurrentDay()
        }
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "с \(week.from) до \(week.to)"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        let menu = SetUpDatesMenu()
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        sections.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    private func SetUpDatesMenu()-> UIMenu {
        
        let currentDay = dateManager.getCurrentDate()
        
        let actions = timetable.enumerated().map { (index: Int, date: TimeTable) -> UIAction in
            let currentDay = week.dayNames[currentDay]
            let day = week.dayNames[date.date]!
            let actionHandler: UIActionHandler = { [weak self] _ in
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
            }
            return UIAction(title: week.dayNames[date.date]!.lowercased(), state: currentDay == day ? .on : .off, handler: actionHandler)
        }
        let datesList = UIMenu(title: "дни недели", options: .singleSelection, children: actions)
        return datesList
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
        GetTimeTable()
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
    
    private func SetUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.startAnimating()
    }
    
    func GetTimeTable() {
        self.spinner.startAnimating()
        self.noTimeTableLabel.isHidden = true
        self.timetable = []
        self.tableView.reloadData()
        service.GetTimeTableWeek(groupId: group, startDate: week.from, endDate: week.to) { result in
            switch result {
            case .success(let timetable):
                var arr = [TimeTable]()
                if !timetable.isEmpty {
                    for timetable in timetable {
                        let data = timetable.disciplines.filter { $0.subgroup == self.subgroup || $0.subgroup == 0 || (self.subgroup == 0 && ($0.subgroup == 1 || $0.subgroup == 2)) }
                        let timeTable = TimeTable(date: timetable.date, groupName: timetable.groupName, disciplines: data)
                        if !timetable.disciplines.isEmpty {
                            arr.append(timeTable)
                        }
                    }
                    DispatchQueue.main.async {
                        self.timetable = arr
                        self.tableView.reloadData()
                        self.spinner.stopAnimating()
                        self.refreshControl.endRefreshing()
                        self.noTimeTableLabel.isHidden = true
                        self.SetUpNavigation()
                    }
                } else {
                    self.noTimeTableLabel.isHidden = false
                    self.spinner.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.SetUpNavigation()
                }
            case .failure(let error):
                self.spinner.stopAnimating()
                self.noTimeTableLabel.text = "Ошибка"
                self.noTimeTableLabel.isHidden = false
                self.refreshControl.endRefreshing()
                self.SetUpNavigation()
                print(error.localizedDescription)
            }
        }
    }
    
    func ScrollToCurrentDay() {
        let currentDate = dateManager.getCurrentDate()
        timetable.enumerated().forEach { (index: Int, timetable: TimeTable) in
            if timetable.date == currentDate {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: 0, section: index)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
}