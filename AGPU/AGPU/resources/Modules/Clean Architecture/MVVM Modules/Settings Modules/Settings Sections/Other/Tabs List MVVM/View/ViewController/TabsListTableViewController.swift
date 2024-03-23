//
//  TabsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

class TabsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = TabsListTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Список вкладок"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        let moveButton = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(moveTabs))
        moveButton.tintColor = .label
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        dismiss(animated: true)
    }
    
    @objc private func moveTabs() {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
    private func setUpTable() {
        tableView.register(TabItemTableViewCell.self, forCellReuseIdentifier: TabItemTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.getData()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.saveTabsPosition(tabs: TabsList.tabs, sourceIndexPath.row, destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TabsList.tabs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TabItemTableViewCell.identifier, for: indexPath) as? TabItemTableViewCell else {return UITableViewCell()}
        cell.configure(tab: TabsList.tabs[indexPath.row])
        return cell
    }
}
