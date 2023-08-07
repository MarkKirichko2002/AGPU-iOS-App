//
//  SubGroupsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import UIKit

class SubGroupsListTableViewController: UITableViewController {

    let subgroups = [1,2]
    
    // MARK: - сервисы
    private let viewModel = SubGroupsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.title = "Подгруппы"
        BindViewModel()
    }
    
    private func BindViewModel() {
        viewModel.registerChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectSubGroup(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subgroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = "\(subgroups[indexPath.row])-я подгруппа"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isSubGroupSelected(index: indexPath.row) ? .systemGreen : .black
        cell.accessoryType = viewModel.isSubGroupSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
