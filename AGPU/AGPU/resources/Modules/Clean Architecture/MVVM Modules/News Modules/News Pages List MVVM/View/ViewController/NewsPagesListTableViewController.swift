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
    
    // MARK: - сервисы
    private var viewModel: NewsPagesListViewModel!
    
    // MARK: - Init
    init(currentPage: Int, countPages: Int) {
        self.currentPage = currentPage
        self.countPages = countPages
        self.viewModel = NewsPagesListViewModel(currentPage: currentPage, countPages: countPages)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Выберите страницу"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    private func SetUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func BindViewModel() {
        viewModel.SetUpData()
        viewModel.registerPageSelectedHandler { category in
            self.navigationItem.title = category
        }
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
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
        cell.textLabel?.textColor = viewModel.isCurrentPage(index: indexPath.row) ? .systemGreen : .black
        cell.accessoryType = viewModel.isCurrentPage(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}