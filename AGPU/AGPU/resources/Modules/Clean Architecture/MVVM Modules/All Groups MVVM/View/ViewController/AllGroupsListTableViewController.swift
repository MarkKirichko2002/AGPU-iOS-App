//
//  AllGroupsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit

class AllGroupsListTableViewController: UITableViewController {

    private var group: String = ""
    // MARK: - сервисы
    private var viewModel: AllGroupsListViewModel!
    
    init(group: String) {
        self.group = group
        self.viewModel = AllGroupsListViewModel(group: group)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        
        navigationItem.title = "Список групп"
        
        let closebutton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        closebutton.tintColor = .black
        let menu = viewModel.makeGroupsMenu()
        viewModel.scrollHandler = { (section, index) in
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(row: index, section: section), at: .top, animated: true)
            }
        }
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        sections.tintColor = .black
        navigationItem.leftBarButtonItem = closebutton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func SetUpTable() {
        tableView.register(UINib(nibName: FacultyGroupTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FacultyGroupTableViewCell.identifier)
    }
    
    private func BindViewModel() {
        viewModel.scrollToSelectedGroup { section, index in
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: index, section: section)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        viewModel.registerGroupSelectedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        return FacultyGroups.groups[section].name.abbreviation()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.SelectGroup(section: indexPath.section, index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfGroupSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FacultyGroups.groups[section].groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupSection = viewModel.groupSectionItem(section: indexPath.section)
        let group = viewModel.groupItem(section: indexPath.section, index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FacultyGroupTableViewCell.identifier, for: indexPath) as? FacultyGroupTableViewCell else {return UITableViewCell()}
        cell.tintColor = .systemGreen
        cell.GroupName.textColor = viewModel.isGroupSelected(section: indexPath.section, index: indexPath.row) ? .systemGreen : .black
        cell.accessoryType = viewModel.isGroupSelected(section: indexPath.section, index: indexPath.row) ? .checkmark : .none
        cell.configure(facultyIcon: self.viewModel.currentFacultyIcon(section: indexPath.section, abbreviation: groupSection.name.abbreviation()), group: group)
        return cell
    }
}
