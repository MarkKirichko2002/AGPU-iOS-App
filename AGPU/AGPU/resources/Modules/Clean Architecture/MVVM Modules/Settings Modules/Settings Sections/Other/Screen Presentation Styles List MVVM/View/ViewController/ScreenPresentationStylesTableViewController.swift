//
//  ScreenPresentationStylesTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.05.2024.
//

import UIKit

class ScreenPresentationStylesTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = ScreenPresentationStylesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "eye", title: "Выберите отображение", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectPresentationStyle(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.presentationStyleItemsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = viewModel.presentationStyleItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = style.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.accessoryType = viewModel.isPresentationStyleSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
