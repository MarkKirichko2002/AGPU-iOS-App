//
//  UserStatusListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import UIKit

class UserStatusListTableViewController: UITableViewController {

    @objc private let viewModel = UserStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }

    private func setUpNavigation() {
        navigationItem.title = "Выберите статус"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        self.sendScreenWasClosedNotification()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: UserStatusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UserStatusTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.chooseStatus(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.statusListCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserStatusTableViewCell.identifier, for: indexPath) as? UserStatusTableViewCell else {return UITableViewCell()}
        let status = viewModel.statusItem(index: indexPath.row)
        cell.StatusName.textColor = viewModel.isStatusSelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isStatusSelected(index: indexPath.row) ? .checkmark : .none
        cell.configure(type: status)
        return cell
    }
}
