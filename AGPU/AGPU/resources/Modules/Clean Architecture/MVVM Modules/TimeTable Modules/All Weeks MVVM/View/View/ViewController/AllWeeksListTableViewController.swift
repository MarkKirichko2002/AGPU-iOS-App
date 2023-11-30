//
//  AllWeeksListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import UIKit

class AllWeeksListTableViewController: UITableViewController {
    
    private var group: String = ""
    private var subgroup: Int = 0
    
    // MARK: - сервисы
    private let viewModel = AllWeeksListViewModel()
    
    // MARK: - UI
    private let refreshControll = UIRefreshControl()
    
    // MARK: - Init
    init(group: String, subgroup: Int) {
        self.group = group
        self.subgroup = subgroup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("группа: \(self.group)")
        setUpNavigation()
        setUpTable()
        setUpRefreshControl()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Список недель"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }

    private func setUpTable() {
        tableView.rowHeight = 130
        tableView.register(UINib(nibName: WeekTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WeekTableViewCell.identifier)
    }
    
    private func setUpRefreshControl() {
        tableView.addSubview(self.refreshControll)
        refreshControll.addTarget(self, action: #selector(refreshWeeks), for: .valueChanged)
    }
    
    @objc private func refreshWeeks() {
        viewModel.GetWeeks()
    }
    
    private func bindViewModel() {
        viewModel.GetWeeks()
        viewModel.registerIsChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControll.endRefreshing()
                self.viewModel.getCurrentWeek()
                self.tableView.isUserInteractionEnabled = false
            }
        }
        
        self.viewModel.registerScrollHandler { row in
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: row, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                self.navigationItem.title = "Текущая неделя \(row + 1)"
            }
        }
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("прокрутка завершилась")
        HapticsManager.shared.hapticFeedback()
        tableView.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let week = viewModel.weekItem(index: indexPath.row)
        let vc = TimeTableWeekListTableViewController(group: self.group, subgroup: self.subgroup, week: week)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfWeeks()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let week = viewModel.weekItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekTableViewCell.identifier, for: indexPath) as? WeekTableViewCell else {return UITableViewCell()}
        cell.configure(week: week)
        cell.DateRangeLabel.textColor = viewModel.isCurrentWeek(index: indexPath.row) ? .systemGreen : .label
        cell.WeekID.textColor = viewModel.isCurrentWeek(index: indexPath.row) ? .systemGreen : .label
        return cell
    }
}
