//
//  TimeTableSearchListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 28.10.2023.
//

import UIKit

class TimeTableSearchListTableViewController: UITableViewController, UISearchResultsUpdating {
   
    var results = [SearchResultModel]()
    var isSettings = false
    
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
        if isSettings {
            navigationItem.title = "Поиск"
        } else {
            let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
            closeButton.tintColor = .label
            navigationItem.title = "Поиск"
            navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
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
        let object = results[indexPath.row]
        let result = SearchTimetableModel(name: object.searchContent, owner: currentOwner(type: object.type))
        NotificationCenter.default.post(name: Notification.Name("object selected"), object: result)
        if isSettings {
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
        } else {
            self.dismiss(animated: true)
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row].searchContent
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
    
    private func currentOwner(type: SearchType)-> String {
        switch type {
        case .Teacher:
            return "TEACHER"
        case .Group:
            return "GROUP"
        case .Classroom:
            return "CLASSROOM"
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        service.getSearchResults(searchText: text) { [weak self] result in
            switch result {
            case .success(let data):
                self?.results = data
                print(data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
