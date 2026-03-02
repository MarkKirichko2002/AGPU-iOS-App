//
//  TimeTableForCurrentBuildingViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.12.2023.
//

import UIKit

final class TimeTableForCurrentBuildingViewController: UIViewController {
    
    var timetable = TimeTable(id: "", date: "", disciplines: [])
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let service = TimeTableService()
    let timetablePseudonymManager = PseudonymManager()
    
    // MARK: - UI
    let tableView = UITableView()
    let infoLabel = UILabel()
    
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
        setUpLabel()
        setUpTimetable()
        checkPairs()
    }
    
    private func setUpNavigation() {
        let date = dateManager.getCurrentDate()
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .done, target: self, action: #selector(shareTimetable))
        closeButton.tintColor = .label
        shareButton.tintColor = .label
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
                self.ShareImage(image: image, title: self.timetable.id, text: "\(dayOfWeek) \(self.timetable.date)")
                HapticsManager.shared.hapticFeedback()
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
    
    private func setUpLabel() {
        view.addSubview(infoLabel)
        infoLabel.text = "Нет пар"
        infoLabel.font = .systemFont(ofSize: 18, weight: .medium)
        infoLabel.isHidden = true
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpTimetable() {
        timetable.disciplines = timetablePseudonymManager.setUpTimetablePseudonyms(pairs: &timetable.disciplines)
        timetable.disciplines = timetable.disciplines.sorted { dateManager.compareTimes(time1: "\($0.time.components(separatedBy: "-")[0]):00", time2: "\($1.time.components(separatedBy: "-")[0]):00") == .orderedAscending}
        DispatchQueue.main.async {
            self.navigationItem.title = self.timetablePseudonymManager.setUpDayOfWeekPseudonym(date: self.timetable.date)
            self.tableView.reloadData()
        }
    }
    
    func checkPairs() {
        if !timetable.disciplines.isEmpty {
            self.infoLabel.isHidden = true
        } else {
            self.infoLabel.isHidden = false
        }
    }
}
