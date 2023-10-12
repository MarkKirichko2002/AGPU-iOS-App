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
        // MARK: - Секция "Основное"
        // Your Status
        tableView.register(UINib(nibName: YourStatusOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: YourStatusOptionTableViewCell.identifier)
        // Selected Faculty
        tableView.register(UINib(nibName: SelectedFacultyOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SelectedFacultyOptionTableViewCell.identifier)
        // MARK: - Секция "Другие опции"
        // Shake To Recall
        tableView.register(UINib(nibName: ShakeToRecallOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ShakeToRecallOptionTableViewCell.identifier)
        // Personalized App Icons
        tableView.register(UINib(nibName: AppIconTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AppIconTableViewCell.identifier)
        // MARK: - Другое
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
