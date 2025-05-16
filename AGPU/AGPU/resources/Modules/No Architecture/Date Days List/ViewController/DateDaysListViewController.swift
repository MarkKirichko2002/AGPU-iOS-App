//
//  DateDaysListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.01.2025.
//

import UIKit

protocol DateDaysListViewControllerDelegate: AnyObject {
    func timeWasSelected(date: String, time: String)
    func buildingWasSelected(date: String, building: AGPUBuildingModel)
    func pairTypeSelected(date: String, type: PairType)
}

final class DateDaysListViewController: UIViewController {

    var days: [TimeTable] = []
    var week: WeekModel
    var selectedDate = ""
    var typesDict: [String: PairType] = [:]
    var buildingsDict: [String: AGPUBuildingModel] = [:]
    var timesDict: [String: String] = [:]
    var isSection = false
    weak var delegate: DateDaysListViewControllerDelegate?
    
    var tableView = UITableView()
    
    // MARK: - сервисы
    let dateManager = DateManager()
    
    init(days: [TimeTable], week: WeekModel, typesDict: [String: PairType], buildingsDict: [String: AGPUBuildingModel], timesDict:  [String: String]) {
        self.days = days
        self.week = week
        self.typesDict = typesDict
        self.buildingsDict = buildingsDict
        self.timesDict = timesDict
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
        navigationItem.title = "Дни недели"
        if isSection {
            setUpBackButton()
        } else {
            setUpCloseButton()
        }
    }
    
    private func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: - UITableViewDelegate
extension DateDaysListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = days[indexPath.row]
        let vc = TimetableFilterCategoriesListTableViewController(date: day.date, type:  typesDict[day.date]!, disciplines: day.disciplines, building: buildingsDict[day.date]!, time: timesDict[day.date]!)
        vc.isSection = true
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        selectedDate = day.date
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension DateDaysListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = days[indexPath.row]
        let dayOfWeek = week.dayNames[day.date]!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(dayOfWeek): \(day.date)"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}

// MARK: - PairTypesListTableViewControllerDelegate
extension DateDaysListViewController: TimetableFilterCategoriesListTableViewControllerDelegate {
    
    func timeWasSelected(time: String) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.timeWasSelected(date: self.selectedDate, time: time)
            self.dismiss(animated: true)
        }
    }
    
    func buildingWasSelected(building: AGPUBuildingModel) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.buildingWasSelected(date: self.selectedDate, building: building)
            self.dismiss(animated: true)
        }
    }
    
    func pairTypeWasSelected(type: PairType) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.pairTypeSelected(date: self.selectedDate, type: type)
            self.dismiss(animated: true)
        }
    }
}
