//
//  TimeTableSearchListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 28.10.2023.
//

import UIKit

class TimeTableSearchListTableViewController: UITableViewController, UISearchResultsUpdating {
   
    var results = [SearchResultModel]()
    
    private let service = TimeTableService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpNavigation()
        setUpSearchBar()
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.title = "Поиск преподавателей"
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    private func setUpSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "введите текст"
        navigationItem.searchController = search
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teacher = results[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name("teacher selected"), object: teacher.ownerID)
        self.dismiss(animated: true)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row].searchContent
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        service.getSearchResults(searchText: text) { [weak self] result in
            switch result {
            case .success(let data):
                let filteredData = data.filter { $0.type == .Teacher}
                self?.results = filteredData
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
