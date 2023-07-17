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
        SetUpNavigation()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        BindViewModel()
        viewModel.GetGroups(by: faculty)
    }
    
    private func SetUpNavigation() {
        // Создаем кастомное view для заголовка
        let titleView = UIView()
        
        // Создаем изображение
        let imageView = UIImageView(image: UIImage(named: faculty.icon))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(imageView)
        
        // Создаем текстовую метку
        let label = UILabel()
        label.text = faculty.abbreviation
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(label)
        
        // Устанавливаем констреинты для изображения и текстовой метки
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 45),
            imageView.heightAnchor.constraint(equalToConstant: 45),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
        
        // Устанавливаем кастомное view в качестве заголовка navigation item
        navigationItem.titleView = titleView
        
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
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return cell
    }
}
