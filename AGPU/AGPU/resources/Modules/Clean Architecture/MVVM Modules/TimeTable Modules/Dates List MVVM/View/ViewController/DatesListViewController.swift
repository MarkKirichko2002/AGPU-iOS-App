//
//  DatesListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

class DatesListViewController: UIViewController {

    // MARK: - UI
    private let noDatesLabel = UILabel()
    private let tableView = UITableView()
    
    // MARK: - сервисы
    let viewModel = DatesListViewModel()
    
    var id: String = ""
    var owner: String = ""
    
    // MARK: - Init
    init(id: String, owner: String) {
        self.id = id
        self.owner = owner
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
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
        options.tintColor = .label
        navigationItem.title = "Даты"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = options
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpMenu()-> UIMenu {
        
        let addDateAction = UIAction(title: "Выбрать даты") { _ in
            let vc = CalendarMultipleDatesViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let getTimetable = UIAction(title: "Расписание") { _ in
            let vc = TimeTableDatesListViewController(id: self.id, owner: self.owner, dates: self.viewModel.dates)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        return UIMenu(title: "Даты", children: [
            addDateAction,
            getTimetable
        ])
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
            if !self.viewModel.dates.isEmpty {
                self.noDatesLabel.isHidden = true
            } else {
                self.noDatesLabel.isHidden = false
            }
        }
        viewModel.getDates()
    }
}
