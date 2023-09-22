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
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "settings", title: "Настройки", frame: .zero)
        navigationItem.titleView = titleView
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UINib(nibName: UserStatusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UserStatusTableViewCell.identifier)
        tableView.register(UINib(nibName: AGPUFacultyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AGPUFacultyTableViewCell.identifier)
        tableView.register(UINib(nibName: ShakeToRecallOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ShakeToRecallOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: AppThemesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AppThemesTableViewCell.identifier)
        tableView.register(UINib(nibName: AppFeaturesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AppFeaturesTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
