//
//  RecentDatesListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

protocol RecentDatesListViewControllerDelegate: AnyObject {
    func dateSelected(model: TimeTableChangesModel)
}

class RecentDatesListViewController: UIViewController {

    // MARK: - UI
    private let noDatesLabel = UILabel()
    private let tableView = UITableView()
    
    // MARK: - ASPUButtonFavouriteActionsListViewModel
    let viewModel = RecentDatesListViewModel()
    
    var id: String = ""
    var owner: String = ""
    
    weak var delegate: RecentDatesListViewControllerDelegate?
    
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
        
        let titleView = CustomTitleView(image: "time", title: "Недавние даты", frame: .zero)
        
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        setUpEditButton(title: "Править")
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        sendScreenWasClosedNotification()
        dismiss(animated: true)
    }
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveDates))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func moveDates() {
        if tableView.isEditing {
            setUpEditButton(title: "Править")
            tableView.isEditing = false
        } else {
            setUpEditButton(title: "Готово")
            tableView.isEditing = true
        }
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
