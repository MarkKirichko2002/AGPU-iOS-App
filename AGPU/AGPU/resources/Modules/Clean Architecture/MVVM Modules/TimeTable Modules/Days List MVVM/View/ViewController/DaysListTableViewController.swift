//
//  DaysListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import UIKit

protocol DaysListTableViewControllerDelegate: AnyObject {
    func dayTypeSelected(type: DayType)
    func dateSelected(date: String)
    func weekSelected(week: WeekModel)
    func datesSelected(dates: [String])
}

enum DayType: String, CaseIterable {
    case near = "Ближайшие"
    case week = "Недели"
    case selected = "Выбранные"
    case recent = "Недавние"
}

final class DaysListTableViewController: UIViewController {
    
    private let tableView = UITableView()
    private let noDatesLabel = UILabel()
    
    private var id = ""
    private var currentDate = ""
    private var owner = ""
    private var viewModel: DaysListViewModel
    
    weak var delegate: DaysListTableViewControllerDelegate?
    
    // MARK: - Init
    init(id: String, currentDate: String, owner: String, dayType: DayType, week: WeekModel, dates: [String]) {
        self.id = id
        self.currentDate = currentDate
        self.owner = owner
        self.viewModel = DaysListViewModel(id: id, currentDate: currentDate, owner: owner, dayType: dayType, week: week, dates: dates)
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
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        let menu = UIBarButtonItem(image: UIImage(named: "sections"), menu: makeMenu())
        menu.accessibilityIdentifier = "menu"
        menu.tintColor = .label
        navigationItem.title = viewModel.titleForNavigation()
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = menu
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func makeMenu()-> UIMenu {
        let types = DayType.allCases.map { type in UIAction(title: type.rawValue, state: viewModel.dayType == type ? .on : .off) { _ in
            switch type {
            case .near:
                self.viewModel.dayType = type
                self.viewModel.resetData()
                self.delegate?.dayTypeSelected(type: .near)
                self.updateMenu()
            case .week:
                let vc = AllWeeksListTableViewController(id: self.id, subgroup: 0, owner: self.owner)
                vc.delegate = self
                vc.isAR = true
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            case .selected:
                let vc = CalendarMultipleDatesViewController(id: self.id, date: self.currentDate, subgroup: 0, owner: self.owner)
                vc.delegate = self
                vc.isForList = true
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            case .recent:
                self.viewModel.dayType = type
                self.viewModel.resetData()
                self.delegate?.dayTypeSelected(type: .recent)
                self.updateMenu()
            }
        }
        }
        return UIMenu(title: "Список дней", children: types)
    }
    
    func updateMenu() {
        guard let item = self.navigationItem.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "menu" }) else {return}
        item.menu = makeMenu()
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: DayTableViewCell.identifier)
    }
    
    private func setUpLabel() {
        view.addSubview(noDatesLabel)
        noDatesLabel.text = "Список дат пуст"
        noDatesLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noDatesLabel.isHidden = true
        noDatesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDatesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDatesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.days.isEmpty {
                self.noDatesLabel.isHidden = true
            } else {
                self.noDatesLabel.isHidden = false
            }
        }
        viewModel.setUpData()
    }
}

// MARK: - UITableViewDelegate
extension DaysListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.chooseDay(index: indexPath.row)
        delegate?.dateSelected(date: viewModel.dayItem(index: indexPath.row).date)
        dismiss(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension DaysListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dayItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = viewModel.dayItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayTableViewCell.identifier, for: indexPath) as? DayTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.configure(date: "\(day.name): \(day.dayOfWeek) \(day.date)", info: "(\(day.info))", currentDate: "")
        cell.dayName.textColor = viewModel.timeTableColor(index: indexPath.row)
        return cell
    }
}

// MARK: - IDayTableViewCell
extension DaysListTableViewController: IDayTableViewCell {
    
    func dateWasSelected(date: String) {
        let date = date.components(separatedBy: " ").last!
        let vc = CurrentDateTimeTableDayListTableViewController(id: id, date: date, owner: owner)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

// MARK: - AllWeeksListTableViewControllerDelegate
extension DaysListTableViewController: AllWeeksListTableViewControllerDelegate {
    
    func weekWasSelected(week: WeekModel) {
        viewModel.dayType = .week
        delegate?.dayTypeSelected(type: .week)
        delegate?.weekSelected(week: week)
        updateMenu()
        viewModel.setUpWeekData(week: week)
    }
}

// MARK: - CalendarMultipleDatesViewControllerDelegate
extension DaysListTableViewController: CalendarMultipleDatesViewControllerDelegate {
    
    func datesWasSelected(dates: [String]) {
        viewModel.dayType = .selected
        delegate?.dayTypeSelected(type: .selected)
        delegate?.datesSelected(dates: dates)
        updateMenu()
        viewModel.setUpSelectedDays(dates: dates)
    }
}
