//
//  AllGroupsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit

class AllGroupsListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        SetUpNavigation()
    }

    private func SetUpNavigation() {
        
        navigationItem.title = "Список групп"
        
        let closebutton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        closebutton.tintColor = .black
        
        let items = FacultyGroups.groups.enumerated().map { (index: Int, group: FacultyGroupModel) in
            
            return UIAction(title: group.name.abbreviation()) { _ in
                let indexPath = IndexPath(row: 0, section: index)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        let menu = UIMenu(title: "группы", options: .singleSelection, children: items)
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        sections.tintColor = .black
        navigationItem.leftBarButtonItem = closebutton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func isGroupSelected(section: Int, index: Int)-> Bool {
        let group = FacultyGroups.groups[section].groups[index]
        let lastGroup = UserDefaults.standard.string(forKey: "last group")
        if lastGroup == group {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        return FacultyGroups.groups[section].name.abbreviation()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = FacultyGroups.groups[indexPath.section].groups[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.setValue(group, forKey: "last group")
        NotificationCenter.default.post(name: Notification.Name("group changed"), object: group)
        self.dismiss(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return FacultyGroups.groups.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FacultyGroups.groups[section].groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = FacultyGroups.groups[indexPath.section].groups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = group
        cell.textLabel?.textColor = isGroupSelected(section: indexPath.section, index: indexPath.row) ? .systemGreen : .black
        cell.accessoryType = isGroupSelected(section: indexPath.section, index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
