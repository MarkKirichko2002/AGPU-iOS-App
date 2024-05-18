//
//  TabsPositionListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

class TabsPositionListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = TabsPositionListTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        setUpNavigationTitle()
        setUpBackButton()
        setUpEditButton(title: "Править")
    }
    
    func setUpNavigationTitle() {
        navigationItem.title = "Порядок вкладок"
    }
    
    func setUpBackButton() {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: button)
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveTabs))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func moveTabs() {
        if tableView.isEditing {
            NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
            setUpEditButton(title: "Править")
            tableView.isEditing = false
        } else {
            setUpEditButton(title: "Готово")
            tableView.isEditing = true
        }
    }
    
    private func setUpTable() {
        tableView.register(TabItemTableViewCell.self, forCellReuseIdentifier: TabItemTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.getData()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.saveTabsPosition(sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tabs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TabItemTableViewCell.identifier, for: indexPath) as? TabItemTableViewCell else {return UITableViewCell()}
        cell.configure(tab: viewModel.tabs[indexPath.row])
        return cell
    }
}
