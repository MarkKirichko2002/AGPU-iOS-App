//
//  AllWeeksListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import UIKit

class AllWeeksListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = AllWeeksListViewModel()
    
    private var group: String = ""
    private var subgroup: Int = 0
    
    // MARK: - Init
    init(group: String, subgroup: Int) {
        self.group = group
        self.subgroup = subgroup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Список недель"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }

    private func SetUpTable() {
        tableView.rowHeight = 130
        tableView.register(UINib(nibName: WeekTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WeekTableViewCell.identifier)
    }
    
    private func BindViewModel() {
        viewModel.GetWeeks()
        viewModel.registerIsChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.viewModel.GetCurrentWeek()
            self.viewModel.registerScrollHandler { row in
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: row, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    self.navigationItem.title = "Текущая неделя \(row + 1)"
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TimeTableWeekListTableViewController(group: self.group, subgroup: self.subgroup, week: viewModel.weeks[indexPath.row])
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weeks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekTableViewCell.identifier, for: indexPath) as? WeekTableViewCell else {return UITableViewCell()}
        cell.configure(week: viewModel.weeks[indexPath.row])
        cell.DateRangeLabel.textColor = viewModel.isCurrentWeek(index: indexPath.row) ? .systemGreen : .black
        cell.WeekID.textColor = viewModel.isCurrentWeek(index: indexPath.row) ? .systemGreen : .black
        return cell
    }
}
