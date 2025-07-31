//
//  AllWeeksListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import UIKit

protocol AllWeeksListTableViewControllerDelegate: AnyObject {
    func weekWasSelected(week: WeekModel)
}

final class AllWeeksListTableViewController: UIViewController {
    
    private var id: String = ""
    private var subgroup: Int = 0
    private var owner: String = ""
    
    var isNotify = false
    var isAR = false
    var isTab = false
    
    weak var delegate: AllWeeksListTableViewControllerDelegate?
    weak var screenDelegate: ScreenClosedDelegate?
    
    // MARK: - сервисы
    private let viewModel = AllWeeksListViewModel()
    private let animation = AnimationClass()
    
    // MARK: - UI
    private let refreshControll = UIRefreshControl()
    private let spinner: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "clock")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let tableView = UITableView()
    
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
        setUpNavigation()
        setUpTable()
        setUpRefreshControl()
        setUpIndicatorView()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .done, target: self, action: #selector(refreshWeeks))
        refreshButton.accessibilityIdentifier = "refresh button"
        refreshButton.tintColor = .label
        navigationItem.title = "Загрузка..."
        if !isTab {
            navigationItem.rightBarButtonItem = refreshButton
            navigationItem.leftBarButtonItem = closeButton
        } else {
            navigationItem.rightBarButtonItem = refreshButton
        }
        navigationItem.toggleRefreshButtonFromRight(on: false)
    }
    
    @objc private func closeScreen() {
        if isNotify {
            screenDelegate?.screenWasClosed()
        }
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.rowHeight = 130
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: WeekTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WeekTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func setUpRefreshControl() {
        tableView.addSubview(self.refreshControll)
        refreshControll.addTarget(self, action: #selector(refreshWeeks), for: .valueChanged)
    }
    
    @objc func refreshWeeks() {
        navigationItem.title = "Загрузка..."
        viewModel.weeks = []
        viewModel.currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: [:])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        startLoadingAnimation()
        navigationItem.toggleRefreshButtonFromRight(on: false)
        viewModel.GetWeeks()
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
    }
    
    private func bindViewModel() {
        
        viewModel.registerIsChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControll.endRefreshing()
                self.viewModel.getCurrentWeek()
                self.tableView.isUserInteractionEnabled = false
            }
            self.stopLoadingAnimation()
        }
        
        viewModel.registerNotScrollHandler {
            DispatchQueue.main.async {
                self.navigationItem.title = "Текущая неделя \(self.viewModel.currentWeek.id)"
                self.tableView.isUserInteractionEnabled = true
            }
        }
        
        viewModel.registerScrollHandler { row in
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: row, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                self.navigationItem.title = "Текущая неделя \(self.viewModel.currentWeek.id)"
            }
        }
        startLoadingAnimation()
        viewModel.GetWeeks()
    }
    
    func startLoadingAnimation() {
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
    }
    
    func stopLoadingAnimation() {
        self.spinner.isHidden = true
        self.animation.stopRotateAnimation(view: self.spinner)
    }
}

// MARK: - UITableViewDelegate
extension AllWeeksListTableViewController: UITableViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("прокрутка завершилась")
        HapticsManager.shared.hapticFeedback()
        navigationItem.toggleRefreshButtonFromRight(on: true)
        tableView.isUserInteractionEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let week = viewModel.weekItem(index: indexPath.row)
        if isAR {
            delegate?.weekWasSelected(week: week)
            dismiss(animated: true)
        } else {
            let vc = TimeTableWeekListTableViewController(id: id, subgroup: subgroup, currentWeek: week, weeks: viewModel.weeks, owner: owner)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
            HapticsManager.shared.hapticFeedback()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AllWeeksListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfWeeks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let week = viewModel.weekItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekTableViewCell.identifier, for: indexPath) as? WeekTableViewCell else {return UITableViewCell()}
        cell.configure(week: week)
        cell.DateRangeLabel.textColor = viewModel.isSelectedWeek(index: indexPath.row) ? .systemGreen : .label
        cell.WeekID.textColor = viewModel.isSelectedWeek(index: indexPath.row) ? .systemGreen : .label
        return cell
    }
}

// MARK: - TimeTableWeekListTableViewControllerDelegate
extension AllWeeksListTableViewController: TimeTableWeekListTableViewControllerDelegate {
    
    func checkWeek(week: WeekModel) {
        if viewModel.currentWeek.id != week.id {
            viewModel.currentWeek = week
            tableView.reloadData()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.tableView.scrollToRow(at: IndexPath(row: week.id - 1, section: 0), at: .middle, animated: true)
            }
            tableView.isUserInteractionEnabled = false
            navigationItem.title = "Неделя \(week.id) (Выбрано)"
        }
    }
}
