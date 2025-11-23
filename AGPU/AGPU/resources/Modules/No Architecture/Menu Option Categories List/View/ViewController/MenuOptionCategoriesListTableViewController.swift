//
//  MenuOptionCategoriesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 10.11.2025.
//

import UIKit

final class MenuOptionCategoriesListTableViewController: UITableViewController {

    let categories = menuOptionCategories.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    func setUpNavigation() {
        let titleView = CustomTitleView(image: "sections icon", title: "Категории меню", frame: .zero)
        navigationItem.titleView = titleView
        setUpCloseButton()
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MenuOptionsListTableViewController(category: categories[indexPath.row])
        vc.isSettings = true
        navigationController?.pushViewController(vc, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
