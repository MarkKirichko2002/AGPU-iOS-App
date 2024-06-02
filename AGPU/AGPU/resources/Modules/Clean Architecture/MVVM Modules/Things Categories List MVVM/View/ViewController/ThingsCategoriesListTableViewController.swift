//
//  ThingsCategoriesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.05.2024.
//

import UIKit

class ThingsCategoriesListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = ThingsCategoriesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
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
        tableView.register(ThingCategoryTableViewCell.self, forCellReuseIdentifier: ThingCategoryTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.getCategoriesData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = DocumentsListTableViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = SavedImagesListTableViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = SavedVideosListTableViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoriesCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThingCategoryTableViewCell.identifier, for: indexPath) as? ThingCategoryTableViewCell else {return UITableViewCell()}
        cell.configure(category: viewModel.categoryItem(index: indexPath.row))
        return cell
    }
}

// MARK: - DocumentsListTableViewControllerDelegate
extension ThingsCategoriesListTableViewController: DocumentsListTableViewControllerDelegate {
    
    func dataChanged() {
        viewModel.getCategoriesData()
    }
}

// MARK: - SavedImagesListTableViewControllerDelegate
extension ThingsCategoriesListTableViewController: SavedImagesListTableViewControllerDelegate {
    
    func dataUpdated() {
        viewModel.getCategoriesData()
    }
}

// MARK: - SavedVideosListTableViewControllerDelegate
extension ThingsCategoriesListTableViewController: SavedVideosListTableViewControllerDelegate {
    
    func listUpdated() {
        viewModel.getCategoriesData()
    }
}
