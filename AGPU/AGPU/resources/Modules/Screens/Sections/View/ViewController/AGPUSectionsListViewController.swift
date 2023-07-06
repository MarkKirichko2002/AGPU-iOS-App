//
//  AGPUSectionsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import UIKit

class AGPUSectionsListViewController: UIViewController {

    // MARK: - UI
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Разделы"
        SetUpTable()
        ObserveNotifications()
    }
    
    private func SetUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AGPUSubSectionTableViewCell.self, forCellReuseIdentifier: AGPUSubSectionTableViewCell.identifier)
    }
    
    private func ObserveNotifications() {
        // Выбор раздела
        NotificationCenter.default.addObserver(forName: Notification.Name("ScrollToSection"), object: nil, queue: .main) { notification in
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: notification.object as? Int ?? 0), at: .top, animated: true)
        }
    }
}
