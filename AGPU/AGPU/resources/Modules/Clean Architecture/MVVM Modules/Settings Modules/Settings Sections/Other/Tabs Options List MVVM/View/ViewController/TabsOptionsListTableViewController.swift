//
//  TabsOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.04.2024.
//

import UIKit

class TabsOptionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = TabsOptionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
    }

    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "applicant", title: "Панель вкладок", frame: .zero)
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
        tableView.register(UINib(nibName: TabsPositionOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TabsPositionOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: TabsColorOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TabsColorOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: TabsAnimationOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TabsAnimationOptionTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.observeOptionSelection()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = TabsPositionListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = TabColorsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabsPositionOptionTableViewCell.identifier, for: indexPath) as? TabsPositionOptionTableViewCell else {return UITableViewCell()}
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabsColorOptionTableViewCell.identifier, for: indexPath) as? TabsColorOptionTableViewCell else {return UITableViewCell()}
            cell.configure(color: viewModel.getTabsColor())
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabsAnimationOptionTableViewCell.identifier, for: indexPath) as? TabsAnimationOptionTableViewCell else {return UITableViewCell()}
            return cell
        }
        return UITableViewCell()
    }
}
