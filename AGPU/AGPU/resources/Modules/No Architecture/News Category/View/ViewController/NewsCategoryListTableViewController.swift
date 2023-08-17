//
//  NewsCategoryListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 17.08.2023.
//

import UIKit

class NewsCategoryListTableViewController: UITableViewController {

    var currentCategory = ""
    
    // MARK: - Init
    init(currentCategory: String) {
        self.currentCategory = currentCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        tableView.register(UINib(nibName: NewsCategoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewsCategoryTableViewCell.identifier)
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Категории новостей"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = NewsCategories.categories[indexPath.row]
        if let faculty = AGPUFaculties.faculties.first(where: { $0.abbreviation ==  category.name}) {
            NotificationCenter.default.post(name: Notification.Name("faculty"), object: faculty)
            self.currentCategory = category.name
            self.tableView.reloadData()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name("faculty"), object: nil)
            self.currentCategory = category.name
            self.tableView.reloadData()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
        self.navigationItem.title = "Выбрана категория \(category.name)"
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsCategories.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = NewsCategories.categories[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCategoryTableViewCell.identifier, for: indexPath) as? NewsCategoryTableViewCell else {return UITableViewCell()}
        cell.configure(category: category)
        cell.tintColor = .systemGreen
        cell.CategoryName.textColor = category.name == currentCategory ? .systemGreen : .black
        cell.accessoryType = category.name == currentCategory ? .checkmark : .none
        return cell
    }
}
