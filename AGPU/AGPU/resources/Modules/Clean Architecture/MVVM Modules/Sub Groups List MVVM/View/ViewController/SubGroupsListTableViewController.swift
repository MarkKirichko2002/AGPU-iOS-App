//
//  SubGroupsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import UIKit

class SubGroupsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = SubGroupsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        SetUpNavigation()
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        
        navigationItem.title = "Подгруппы"
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
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
        return viewModel.numberOfSubGroups()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = viewModel.subgroupItem(index: indexPath.row).name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isSubGroupSelected(index: indexPath.row) ? .systemGreen : .black
        cell.accessoryType = viewModel.isSubGroupSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
