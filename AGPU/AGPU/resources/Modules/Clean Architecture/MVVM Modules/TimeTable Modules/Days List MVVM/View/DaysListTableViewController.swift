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
    private var viewModel: DaysListViewModel
    
    // MARK: - Init
    init(id: String, currentDate: String, owner: String) {
        self.id = id
        self.currentDate = currentDate
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
        navigationItem.title = "Выберите день"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(day.name): \(day.dayOfWeek) \(day.date) (\(day.info))"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.timeTableColor(index: indexPath.row)
        return cell
    }
}
