//
//  OnlyMainVariantsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.05.2024.
//

import UIKit

class OnlyMainVariantsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = OnlyMainVariantsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }

    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "home icon", title: "Выберите вариант", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        sendScreenWasClosedNotification()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerOnlyMainVariantSelectedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.chooseOnlyMainVariant(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfVariantsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let variant = viewModel.onlyMainVariantItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = variant.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isCurrentOnlyMainVariant(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isCurrentOnlyMainVariant(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
