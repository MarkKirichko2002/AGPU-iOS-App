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
        SetUpNavigation()
        SetUpTable()
        observeViewModel()
    }
    
    private func SetUpNavigation() {
        let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(AddMusic))
        self.navigationItem.rightBarButtonItem = add
    }
    
    @objc private func AddMusic() {
        let storyboard = UIStoryboard(name: "AddMusicViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddMusicViewController") as? AddMusicViewController {
            present(vc, animated: true)
        }
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
