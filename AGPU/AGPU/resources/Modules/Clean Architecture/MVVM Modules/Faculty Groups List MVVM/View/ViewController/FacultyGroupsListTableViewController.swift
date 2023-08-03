//
//  FacultyGroupsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.07.2023.
//

import UIKit

final class FacultyGroupsListTableViewController: UITableViewController {
    
    var faculty: AGPUFacultyModel
    
    // MARK: - Init
    init(
        faculty: AGPUFacultyModel
    ) {
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
        SetUpNavigation()
        SetUpSwipeGesture()
        SetUpTable()
        BindViewModel()
        viewModel.GetGroups(by: faculty)
    }
    
    private func SetUpNavigation() {
        let titleView = CustomTitleView(
            image: faculty.icon,
            title: faculty.abbreviation,
            frame: .zero
        )
        navigationItem.titleView = titleView
        
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
    
    private func SetUpTable() {
        tableView.register(UINib(nibName: FacultyGroupTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FacultyGroupTableViewCell.identifier)
    }
    
    private func BindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        return viewModel.groups[section].name.abbreviation()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.SelectGroup(section: indexPath.section, index: indexPath.row)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups[section].groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FacultyGroupTableViewCell.identifier, for: indexPath) as? FacultyGroupTableViewCell else {return UITableViewCell()}
        let groups = viewModel.groupItem(section: indexPath.section, index: indexPath.row)
        cell.tintColor = .systemGreen
        cell.accessoryType = viewModel.isGroupSelected(section: indexPath.section, index: indexPath.row) ? .checkmark : .none
        cell.GroupName.textColor = viewModel.isGroupSelected(section: indexPath.section, index: indexPath.row) ? .systemGreen : .black
        cell.configure(faculty: faculty, group: groups)
        return cell
    }
}
