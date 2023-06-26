//
//  SettingsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 20.06.2023.
//

import UIKit

class SettingsListViewController: UIViewController {
    
    @objc let viewModel = SettingsListViewModel()
    
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpTable()
        observeViewModel()
    }
    
    private func SetUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: CustomIconTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomIconTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func observeViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            self.tableView.reloadData()
        }
    }
}
