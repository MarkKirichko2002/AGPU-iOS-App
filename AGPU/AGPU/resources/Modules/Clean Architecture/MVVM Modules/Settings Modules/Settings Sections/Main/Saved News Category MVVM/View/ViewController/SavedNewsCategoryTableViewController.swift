//
//  SavedNewsCategoryTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 04.11.2023.
//

import UIKit

class SavedNewsCategoryTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = SavedNewsCategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "news", title: "Выберите категорию", frame: .zero)
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: SavedNewsCategoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SavedNewsCategoryTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.registerChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectNewsCategory(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsCategories.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = NewsCategories.categories[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedNewsCategoryTableViewCell.identifier, for: indexPath) as? SavedNewsCategoryTableViewCell else {return UITableViewCell()}
        cell.configure(category: category, viewModel: viewModel)
        return cell
    }
}
