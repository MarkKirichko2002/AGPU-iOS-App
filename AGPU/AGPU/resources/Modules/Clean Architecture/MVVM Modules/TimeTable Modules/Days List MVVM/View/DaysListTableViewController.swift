//
//  DaysListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import UIKit

class DaysListTableViewController: UITableViewController {

    var group = ""
    var currentDate = ""
    
    // MARK: - Init
    init(group: String, currentDate: String) {
        self.group = group
        self.currentDate = currentDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpData()
    }

    private func setUpNavigation() {
        navigationItem.title = "Выберите день"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setUpData() {
        DaysList.days[0].date = currentDate
        DaysList.days[1].date = DateManager().nextDay(date: currentDate)
        DaysList.days[2].date = DateManager().previousDay(date: currentDate)
        getTimetableInfo()
    }
    
    private func getTimetableInfo() {
        for day in DaysList.days {
            TimeTableService().getTimeTableDay(groupId: group, date: day.date) { [weak self] result in
                switch result {
                case .success(let timetable):
                    if !timetable.disciplines.isEmpty {
                        let day = DaysList.days.first { $0.date == day.date }
                        let index = DaysList.days.firstIndex(of: day!)
                        DaysList.days[index!].info = "есть пары"
                        self?.tableView.reloadData()
                    } else {
                        let day = DaysList.days.first { $0.date == day.date }
                        let index = DaysList.days.firstIndex(of: day!)
                        DaysList.days[index!].info = "нет пар"
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func chooseDay(index: Int) {
        let day = DaysList.days[index]
        NotificationCenter.default.post(name: Notification.Name("DateWasSelected"), object: day.date)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chooseDay(index: indexPath.row)
        dismiss(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DaysList.days.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let day = DaysList.days[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.text = "\(day.name): \(day.date) (\(day.info))"
        return cell
    }
}
