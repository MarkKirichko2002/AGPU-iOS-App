//
//  FacultyGroupsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.07.2023.
//

import UIKit

class FacultyGroupsListTableViewController: UITableViewController {
    
    var faculty: AGPUFacultyModel
    
    // MARK: - Init
    init(faculty: AGPUFacultyModel) {
        self.faculty = faculty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - сервисы
    @objc private let viewModel = FacultyGroupsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        BindViewModel()
        viewModel.GetGroups(by: faculty)
    }
    
    private func BindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        return Array(viewModel.groups.keys)[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.SelectGroup(section: indexPath.section, index: indexPath.row)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groups.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupsListCount(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let groups = viewModel.groupItem(section: indexPath.section, index: indexPath.row)
        cell.tintColor = .systemGreen
        cell.accessoryType = viewModel.isGroupSelected(section: indexPath.section, index: indexPath.row)
        cell.textLabel?.text = String(describing: groups)
        return cell
        
    }
}
