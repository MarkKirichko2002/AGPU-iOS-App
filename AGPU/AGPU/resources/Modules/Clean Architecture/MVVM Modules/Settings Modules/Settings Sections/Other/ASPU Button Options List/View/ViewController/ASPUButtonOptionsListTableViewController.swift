//
//  ASPUButtonOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import UIKit

class ASPUButtonOptionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = ASPUButtonOptionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "button", title: "АГПУ кнопка", frame: .zero)
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
        tableView.register(UINib(nibName: ASPUButtonIconOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ASPUButtonIconOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: ASPUButtonActionsOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ASPUButtonActionsOptionTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.observeOptionSelected()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ASPUButtonIconsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = ASPUButtonActionsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ASPUButtonIconOptionTableViewCell.identifier, for: indexPath) as? ASPUButtonIconOptionTableViewCell else {return UITableViewCell()}
            cell.configure(action: viewModel.getASPUButtonIconInfo())
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ASPUButtonActionsOptionTableViewCell.identifier, for: indexPath) as? ASPUButtonActionsOptionTableViewCell else {return UITableViewCell()}
            cell.configure(action: viewModel.getASPUButtonActionInfo())
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
