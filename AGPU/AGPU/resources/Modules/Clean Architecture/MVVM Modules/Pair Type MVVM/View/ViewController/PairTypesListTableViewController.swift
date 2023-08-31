//
//  PairTypesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 31.08.2023.
//

import UIKit

class PairTypesListTableViewController: UITableViewController {
    
    private var type: PairType
    
    // MARK: - Init
    init(type: PairType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Типы пары"
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = PairTypesList.list[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name("TypeWasSelected"), object: type.type)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.dismiss(animated: true)
        }
        self.type = type.type
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PairTypesList.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let type = PairTypesList.list[indexPath.row]
        cell.tintColor = .systemGreen
        cell.textLabel?.text = type.name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.accessoryType = type.type == self.type ? .checkmark : .none
        cell.textLabel?.textColor = type.type == self.type ? .systemGreen : .black
        return cell
    }
}
