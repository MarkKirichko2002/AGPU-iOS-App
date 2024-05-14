//
//  DaysListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import UIKit

class DaysListTableViewController: UITableViewController {

    private var id = ""
    private var currentDate = ""
    private var owner = ""
    private var viewModel: DaysListViewModel
    
    // MARK: - Init
    init(id: String, currentDate: String, owner: String) {
        self.id = id
        self.currentDate = currentDate
        self.owner = owner
        self.viewModel = DaysListViewModel(id: id, currentDate: currentDate, owner: owner)
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
        let titleView = CustomTitleView(image: "calendar icon", title: "Выберите день", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
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
        viewModel.setUpData()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.chooseDay(index: indexPath.row)
        dismiss(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let daysCount = DaysList.days.count
        return daysCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = DaysList.days[indexPath.row]
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
