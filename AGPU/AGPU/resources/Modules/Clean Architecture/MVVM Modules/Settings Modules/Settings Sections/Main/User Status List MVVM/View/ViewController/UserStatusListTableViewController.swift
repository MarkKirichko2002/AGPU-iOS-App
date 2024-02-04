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
        let titleView = CustomTitleView(image: "profile icon", title: "Выберите статус", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
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
        let status = viewModel.statusItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserStatusTableViewCell.identifier, for: indexPath) as? UserStatusTableViewCell else {return UITableViewCell()}
        cell.configure(status: status, viewModel: viewModel)
        return cell
    }
}
