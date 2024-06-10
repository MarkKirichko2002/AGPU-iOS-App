//
//  TimeTableFavouriteItemsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.04.2024.
//

import UIKit

protocol TimeTableFavouriteItemsListTableViewControllerDelegate: AnyObject {
    func WasSelected(result: SearchTimetableModel)
}

class TimeTableFavouriteItemsListTableViewController: UIViewController {

    var isSettings = false
    weak var delegate: TimeTableFavouriteItemsListTableViewControllerDelegate?
    
    // MARK: - сервисы
    let viewModel = TimeTableFavouriteItemsListViewModel()
    
    // MARK: - UI
    let tableView = UITableView()
    private let noItemsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "star", title: "Избранное", frame: .zero)
        
        if isSettings {
            let button = UIButton()
            button.tintColor = .label
            button.setImage(UIImage(named: "back"), for: .normal)
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
            
            let backButton = UIBarButtonItem(customView: button)
            
            let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
            addButton.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = backButton
            navigationItem.rightBarButtonItem = addButton
        } else {
            let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
            closeButton.tintColor = .label
            let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
            addButton.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItem = addButton
        }
    }
    
    @objc private func back() {
        sendScreenWasClosedNotification()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        let vc = TimeTableSearchListTableViewController()
        vc.delegate = self
        vc.isFavourite = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeTableFavouriteItemTableViewCell.self, forCellReuseIdentifier: TimeTableFavouriteItemTableViewCell.identifier)
    }
    
    private func setUpLabel() {
        view.addSubview(noItemsLabel)
        noItemsLabel.text = "Список пуст"
        noItemsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noItemsLabel.isHidden = true
        noItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noItemsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noItemsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.items.isEmpty {
                self.noItemsLabel.isHidden = true
            } else {
                self.noItemsLabel.isHidden = false
            }
        }
        viewModel.getItems()
    }
}
