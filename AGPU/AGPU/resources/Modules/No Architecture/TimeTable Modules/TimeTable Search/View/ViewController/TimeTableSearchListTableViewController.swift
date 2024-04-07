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
    let search = UISearchController(searchResultsController: nil)
    
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
        navigationItem.title = "Поиск"
        if isSettings {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
            let button = UIButton()
            button.tintColor = .label
            button.setImage(UIImage(named: "back"), for: .normal)
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
            let backButton = UIBarButtonItem(customView: button)
            navigationItem.leftBarButtonItem = backButton
        } else {
            let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
            closeButton.tintColor = .label
            navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpSearchBar() {
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "введите текст"
        navigationItem.searchController = search
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chooseResult(index: indexPath.row)
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
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension TimeTableSearchListTableViewController {
    
    func chooseResult(index: Int) {
        let object = results[index]
        let result = SearchTimetableModel(name: object.searchContent, owner: currentOwner(type: object.type))
        if isSettings {
            UserDefaults.standard.setValue(result.owner, forKey: "recentOwner")
            UserDefaults.standard.setValue(result.name, forKey: "group")
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
        NotificationCenter.default.post(name: Notification.Name("object selected"), object: result)
        self.tableView.reloadData()
    }
}
