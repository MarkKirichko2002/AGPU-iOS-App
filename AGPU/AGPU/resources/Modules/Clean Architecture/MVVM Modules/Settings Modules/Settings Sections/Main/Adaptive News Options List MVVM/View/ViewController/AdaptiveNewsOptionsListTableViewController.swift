//
//  AdaptiveNewsOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 22.03.2024.
//

import UIKit

class AdaptiveNewsOptionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = AdaptiveNewsOptionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpNavigation()
        bindViewModel()
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: SavedNewsCategoryOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SavedNewsCategoryOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: AdaptToWebOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AdaptToWebOptionTableViewCell.identifier)
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "mail", title: "Новости", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        dismiss(animated: true)
    }
    
    private func bindViewModel() {
        viewModel.observeCategorySelected()
        viewModel.registerDataHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = SavedNewsCategoryTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedNewsCategoryOptionTableViewCell.identifier, for: indexPath) as? SavedNewsCategoryOptionTableViewCell else {return UITableViewCell()}
            cell.configure(category: viewModel.getSavedNewsCategoryInfo())
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdaptToWebOptionTableViewCell.identifier, for: indexPath) as? AdaptToWebOptionTableViewCell else {return UITableViewCell()}
            return cell
        }
    }
}