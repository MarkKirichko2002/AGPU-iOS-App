//
//  NewsPagesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2023.
//

import UIKit

class NewsPagesListTableViewController: UITableViewController {
    
    private var currentPage: Int = 0
    private var countPages: Int = 0
    private var abbreviation: String?
    
    // MARK: - сервисы
    private var viewModel: NewsPagesListViewModel!
    
    // MARK: - Init
    init(currentPage: Int, countPages: Int, abbreviation: String?) {
        self.currentPage = currentPage
        self.countPages = countPages
        self.viewModel = NewsPagesListViewModel(currentPage: currentPage, countPages: countPages, abbreviation: abbreviation)
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
        navigationItem.title = "Выберите страницу"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        
        viewModel.registerPageSelectedHandler { page in
            
            DispatchQueue.main.async {
                self.navigationItem.title = page
                self.tableView.reloadData()
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
        
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.setUpData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.chooseNewsPage(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPagesInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let page = viewModel.pageItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = page
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isCurrentPage(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isCurrentPage(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
