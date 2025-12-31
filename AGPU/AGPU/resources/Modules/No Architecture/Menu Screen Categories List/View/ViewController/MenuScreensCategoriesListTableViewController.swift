//
//  MenuScreensCategoriesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 10.11.2025.
//

import UIKit

protocol MenuScreensCategoriesListTableViewControllerDelegate: AnyObject {
    func listWasUpdated()
}

final class MenuScreensCategoriesListTableViewController: UITableViewController {

    let categories = MenuScreensCategories.categories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    func setUpNavigation() {
        let titleView = CustomTitleView(image: "mobile", title: "Категории экранов", frame: .zero)
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
        tableView.register(MenuScreensCategoryTableViewCell.self, forCellReuseIdentifier: MenuScreensCategoryTableViewCell.identifier)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MenuCategoryScreensListTableViewController(category: categories[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuScreensCategoryTableViewCell.identifier, for: indexPath) as? MenuScreensCategoryTableViewCell else {return UITableViewCell()}
        cell.configure(for: categories[indexPath.row])
        return cell
    }
}
