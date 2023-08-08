//
//  AGPUNewsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import UIKit

class AGPUNewsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = AGPUNewsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Новости"
    }
    
    private func SetUpTable() {
        tableView.register(UINib(nibName: NewsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    private func BindViewModel() {
        viewModel.GetNews()
        viewModel.registerDataChangedHandler { faculty in
            DispatchQueue.main.async {
                self.navigationItem.title = "Новости \(faculty.abbreviation)"
                self.tableView.reloadData()
            }
        }
        viewModel.ObserveFacultyChanges()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        cell.configure(news: viewModel.news[indexPath.row])
        return cell
    }
}
