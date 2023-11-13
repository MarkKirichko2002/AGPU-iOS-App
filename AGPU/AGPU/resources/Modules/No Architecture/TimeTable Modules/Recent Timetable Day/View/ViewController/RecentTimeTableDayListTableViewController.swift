//
//  RecentTimeTableDayListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 01.11.2023.
//

import UIKit

class RecentTimeTableDayListTableViewController: UIViewController {

    var timetable = TimeTable(date: "", groupName: "", disciplines: [])
    private var group: String = ""
    private var date: String = ""
    
    private let service = TimeTableService()
    private let dateManager = DateManager()
    
    // MARK: - UI
    let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let noTimeTableLabel = UILabel()
    private let refresh = UIRefreshControl()
    
    // MARK: - Init
    init(group: String, date: String) {
        self.group = group
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpRefreshControl()
        setUpIndicatorView()
        setUpLabel()
        getRecentTimetable()
    }

    private func setUpNavigation() {
        navigationItem.title = "\(date) (\(group))"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    @objc private func refreshTimetable() {
        setUpRefreshControl()
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.startAnimating()
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeTableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func setUpRefreshControl() {
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(refreshTimetable), for: .valueChanged)
    }
    
    private func setUpLabel() {
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
    
    func getRecentTimetable() {
        self.spinner.startAnimating()
        self.noTimeTableLabel.isHidden = true
        self.tableView.reloadData()
        service.getTimeTableDay(groupId: group, date: date) { [weak self] result in
            switch result {
            case .success(let timetable):
                if !timetable.disciplines.isEmpty {
                    DispatchQueue.main.async {
                        self?.timetable = timetable
                        self?.tableView.reloadData()
                        self?.spinner.stopAnimating()
                        self?.refresh.endRefreshing()
                        self?.noTimeTableLabel.isHidden = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.spinner.stopAnimating()
                        self?.refresh.endRefreshing()
                        self?.noTimeTableLabel.isHidden = false
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    self?.refresh.endRefreshing()
                    self?.noTimeTableLabel.text = "Ошибка"
                    self?.noTimeTableLabel.isHidden = false
                }
                print(error.localizedDescription)
            }
        }
    }
}
