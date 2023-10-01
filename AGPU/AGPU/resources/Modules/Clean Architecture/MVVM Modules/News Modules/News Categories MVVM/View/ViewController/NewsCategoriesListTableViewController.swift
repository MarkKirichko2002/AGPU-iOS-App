//
//  NewsCategoriesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 17.08.2023.
//

import UIKit

class NewsCategoriesListTableViewController: UITableViewController {

    var currentCategory = ""
    
    // MARK: - сервисы
    private var viewModel: NewsCategoriesListViewModel!
    
    // MARK: - Init
    init(currentCategory: String) {
        self.currentCategory = currentCategory
        self.viewModel = NewsCategoriesListViewModel(currentCategory: currentCategory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Категории новостей"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: NewsCategoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewsCategoryTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        
        
        viewModel.registerCategorySelectedHandler { category in
            
            DispatchQueue.main.async {
                self.navigationItem.title = category
                self.tableView.reloadData()
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
        
        viewModel.getNewsCategoriesInfo()
        
        viewModel.registerDataChangedHandler {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.chooseNewsCategory(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return viewModel.numberOfCategoriesInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let category = viewModel.categoryItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCategoryTableViewCell.identifier, for: indexPath) as? NewsCategoryTableViewCell else {return UITableViewCell()}
        cell.tintColor = .systemGreen
        cell.CategoryName.textColor = viewModel.isCurrentCategory(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isCurrentCategory(index: indexPath.row) ? .checkmark : .none
        cell.configure(category: category)
        return cell
    }
}
