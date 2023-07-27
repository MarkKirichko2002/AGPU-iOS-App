//
//  SettingsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 20.06.2023.
//

import UIKit

final class SettingsListViewController: UIViewController {
   
    // MARK: - сервисы
    @objc let viewModel = SettingsListViewModel()
    
    // MARK: - UI
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpTable()
        BindViewModel()
    }
    
    private func SetUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: AGPUFacultyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AGPUFacultyTableViewCell.identifier)
        tableView.register(UINib(nibName: ShakeToRecallOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ShakeToRecallOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: AppFeaturesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AppFeaturesTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func BindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            self.tableView.reloadData()
        }
    }
}
