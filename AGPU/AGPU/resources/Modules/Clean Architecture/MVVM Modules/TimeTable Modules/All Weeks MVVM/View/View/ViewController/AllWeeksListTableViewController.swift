//
//  AllWeeksListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import UIKit

class AllWeeksListTableViewController: UITableViewController {
    
    private var id: String = ""
    private var subgroup: Int = 0
    private var owner: String = ""
    
    var isNotify = false
    
    // MARK: - сервисы
    private let viewModel = AllWeeksListViewModel()
    
    // MARK: - UI
    private let refreshControll = UIRefreshControl()
    
    // MARK: - Init
    init(id: String, subgroup: Int, owner: String) {
        self.id = id
        self.subgroup = subgroup
        self.owner = owner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self.id)")
        setUpNavigation()
        setUpTable()
        setUpRefreshControl()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.title = "Недели"
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        if isNotify {
            sendScreenWasClosedNotification()
        }
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
        let vc = TimeTableWeekListTableViewController(id: id, subgroup: subgroup, week: week, owner: owner)
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
