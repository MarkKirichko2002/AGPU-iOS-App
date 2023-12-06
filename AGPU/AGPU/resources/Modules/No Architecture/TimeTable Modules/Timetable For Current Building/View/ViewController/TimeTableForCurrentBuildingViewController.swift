//
//  TimeTableForCurrentBuildingViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.12.2023.
//

import UIKit

class TimeTableForCurrentBuildingViewController: UIViewController {
    
    var timetable = TimeTable(date: "", groupName: "", disciplines: []) {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let service = TimeTableService()
    
    // MARK: - UI
    let tableView = UITableView()
    
    // MARK: - Init
    init(timetable: TimeTable) {
        self.timetable = timetable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let date = dateManager.getCurrentDate()
        let dayOfWeek = dateManager.getCurrentDayOfWeek(date: date)
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(closeScreen))
        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .done, target: self, action: #selector(shareTimetable))
        closeButton.tintColor = .label
        shareButton.tintColor = .label
        navigationItem.title = "Сегодня: \(dayOfWeek) \(date)"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    @objc private func shareTimetable() {
        do {
            let json = try JSONEncoder().encode(self.timetable)
            let dayOfWeek = self.dateManager.getCurrentDayOfWeek(date: self.timetable.date)
            self.service.getTimeTableDayImage(json: json) { image in
                self.ShareImage(image: image, title: self.timetable.groupName, text: "\(dayOfWeek) \(self.timetable.date)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeTableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
}
