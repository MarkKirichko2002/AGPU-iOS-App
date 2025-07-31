//
//  TabsOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.04.2024.
//

import UIKit

final class TabsOptionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = TabsOptionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "applicant", title: "Настройки панели", frame: .zero)
        navigationItem.titleView = titleView
        setUpBackButton()
    }
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: TabsPositionOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TabsPositionOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: AdditionalTabOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AdditionalTabOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: TabsColorOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TabsColorOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: FontOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FontOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: TabsIconStyleTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TabsIconStyleTableViewCell.identifier)
        tableView.register(UINib(nibName: TabsAnimationOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TabsAnimationOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: RecentTabOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecentTabOptionTableViewCell.identifier)
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
            HapticsManager.shared.hapticFeedback()
        case 1:
            let vc = AdditionalTabOptionsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 2:
            let vc = TabColorsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 3:
            let vc = TabFontOptionsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 4:
            let vc = TabIconsStyleListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabsPositionOptionTableViewCell.identifier, for: indexPath) as? TabsPositionOptionTableViewCell else {return UITableViewCell()}
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalTabOptionTableViewCell.identifier, for: indexPath) as? AdditionalTabOptionTableViewCell else {return UITableViewCell()}
            cell.configure(option: viewModel.getAdditionalTab())
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabsColorOptionTableViewCell.identifier, for: indexPath) as? TabsColorOptionTableViewCell else {return UITableViewCell()}
            cell.configure(color: viewModel.getTabsColor())
            return cell
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FontOptionTableViewCell.identifier, for: indexPath) as? FontOptionTableViewCell else {return UITableViewCell()}
            cell.configure(font: viewModel.getTabsFont())
            return cell
        } else if indexPath.row == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabsIconStyleTableViewCell.identifier, for: indexPath) as? TabsIconStyleTableViewCell else {return UITableViewCell()}
            cell.configure(style: viewModel.getIconsStyle())
            return cell
        } else if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TabsAnimationOptionTableViewCell.identifier, for: indexPath) as? TabsAnimationOptionTableViewCell else {return UITableViewCell()}
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentTabOptionTableViewCell.identifier, for: indexPath) as? RecentTabOptionTableViewCell else {return UITableViewCell()}
            return cell
        }
    }
}
