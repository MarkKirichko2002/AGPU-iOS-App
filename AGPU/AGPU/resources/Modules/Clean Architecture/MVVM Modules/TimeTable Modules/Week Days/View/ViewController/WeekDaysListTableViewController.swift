//
//  WeekDaysListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 17.03.2024.
//

import UIKit

protocol WeekDaysListTableViewControllerDelegate: AnyObject {
    func dateWasSelected(index: Int)
}

class WeekDaysListTableViewController: UITableViewController {

    private var id = ""
    private var owner = ""
    private var currentDate = ""
    
    weak var delegate: WeekDaysListTableViewControllerDelegate?
    
    private var viewModel: WeekDaysListViewModel
    
    // MARK: - Init
    init(id: String, owner: String, week: WeekModel, timetable: [TimeTable], currentDate: String) {
        self.id = id
        self.owner = owner
        self.currentDate = currentDate
        self.viewModel = WeekDaysListViewModel(id: id, owner: owner, week: week, timetable: timetable)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }

    private func setUpNavigation() {
        navigationItem.title = "Выберите день"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: DayTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        
        viewModel.setUpDays()
        
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.dateWasSelected(index: indexPath.row)
        }
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let daysCount = viewModel.days.count
        return daysCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = viewModel.days[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayTableViewCell.identifier, for: indexPath) as? DayTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.configure(date: "\(day.dayOfWeek): \(day.date)", info: "(\(day.info))", currentDate: currentDate)
        cell.dayName.textColor = viewModel.timeTableColor(index: indexPath.row)
        return cell
    }
}

// MARK: - IDayTableViewCell
extension WeekDaysListTableViewController: IDayTableViewCell {
    
    func dateWasSelected(date: String) {
        let date = date.components(separatedBy: " ").last!
        let vc = RecentTimeTableDayListTableViewController(id: id, date: date, owner: owner)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}
