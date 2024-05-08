//
//  ThingsCategoriesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.05.2024.
//

import UIKit

class ThingsCategoriesListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        
        navigationItem.title = "Выберите категорию"
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        sendScreenWasClosedNotification()
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = DocumentsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = SavedImagesListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThingCategories.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = ThingCategories.allCases[indexPath.row]
        cell.textLabel?.text = category.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
