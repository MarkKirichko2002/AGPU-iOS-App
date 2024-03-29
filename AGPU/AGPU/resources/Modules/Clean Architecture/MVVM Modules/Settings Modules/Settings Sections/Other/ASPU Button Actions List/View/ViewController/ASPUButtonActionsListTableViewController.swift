//
//  ASPUButtonActionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import UIKit

class ASPUButtonActionsListTableViewController: UITableViewController {

    private let viewModel = ASPUButtonActionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Выберите действие"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerDataSelectedHandler {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectAction(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actionItemsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = viewModel.actionItem(index: indexPath.row).rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.accessoryType = viewModel.isActionSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
