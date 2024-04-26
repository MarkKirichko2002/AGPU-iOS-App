//
//  TimeTableFavouriteItemsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.04.2024.
//

import UIKit

class TimeTableFavouriteItemsListTableViewController: UITableViewController {

    var items = [SearchTimetableModel]()
    var isSettings = false
    
    // MARK: - сервисы
    private let realmManager = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "star", title: "Избранное", frame: .zero)
        
        if isSettings {
            let button = UIButton()
            button.tintColor = .label
            button.setImage(UIImage(named: "back"), for: .normal)
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
            
            let backButton = UIBarButtonItem(customView: button)
            
            let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
            addButton.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = backButton
            navigationItem.rightBarButtonItem = addButton
        } else {
            let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
            closeButton.tintColor = .label
            let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
            addButton.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItem = addButton
        }
    }
    
    @objc private func back() {
        sendScreenWasClosedNotification()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        let vc = TimeTableSearchListTableViewController()
        vc.isFavourite = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        refreshData()
    }
    
    private func refreshData() {
        items = realmManager.getTimetableItems()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realmManager.deleteTimetableItem(item: items[indexPath.row])
            refreshData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSettings {
            NotificationCenter.default.post(name: Notification.Name("object selected"), object: items[indexPath.row])
            dismiss(animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
