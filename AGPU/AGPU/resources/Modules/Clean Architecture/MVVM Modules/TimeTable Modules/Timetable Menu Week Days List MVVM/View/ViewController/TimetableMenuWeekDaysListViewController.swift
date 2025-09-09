//
//  TimetableMenuWeekDaysListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.07.2025.
//

import UIKit

protocol TimetableMenuWeekDaysListViewControllerDelegate: AnyObject {
    func dayWasSelected(day: DayModel)
    func menuWasSwiped()
}

final class TimetableMenuWeekDaysListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let noDatesLabel = UILabel()
    
    var id = ""
    var currentDate = ""
    var owner = ""
    var currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: [:]) {
        didSet {
            viewModel.updateData(id: id, date: currentDate, owner: owner, week: currentWeek)
        }
    }
    var edge: UIRectEdge = .left {
        didSet {
            restartGestures()
        }
    }
    private var viewModel: TimetableMenuWeekDaysListViewModel
    
    weak var delegate: TimetableMenuWeekDaysListViewControllerDelegate?
    
    // MARK: - Init
    init(id: String, currentDate: String, owner: String, week: WeekModel, edge: UIRectEdge) {
        self.id = id
        self.currentDate = currentDate
        self.owner = owner
        self.currentWeek = week
        self.edge = edge
        self.viewModel = TimetableMenuWeekDaysListViewModel(id: id, currentDate: currentDate, owner: owner, week: week)
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
        setUpGestures()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.resetData()
    }
    
    private func setUpNavigation() {
        navigationItem.title = viewModel.titleForNavigation()
        setUpCloseButton()
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        delegate?.menuWasSwiped()
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
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
        noDatesLabel.text = "Список дней пуст"
        noDatesLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noDatesLabel.isHidden = true
        noDatesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDatesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDatesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func restartGestures() {
        view.gestureRecognizers?.forEach { view.removeGestureRecognizer($0) }
        setUpGestures()
    }
    
    private func setUpGestures() {
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = edge
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            delegate?.menuWasSwiped()
        }
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if !self.viewModel.days.isEmpty {
                    self.noDatesLabel.isHidden = true
                } else {
                    self.noDatesLabel.isHidden = false
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension TimetableMenuWeekDaysListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.chooseDay(index: indexPath.row)
        delegate?.dayWasSelected(day: viewModel.dayItem(index: indexPath.row))
        dismiss(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TimetableMenuWeekDaysListViewController: UITableViewDataSource {
    
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
extension TimetableMenuWeekDaysListViewController: IDayTableViewCell {
    
    func dateWasSelected(date: String) {
        let date = date.components(separatedBy: " ").last!
        let vc = CurrentDateTimeTableDayListTableViewController(id: id, date: date, owner: owner)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}
