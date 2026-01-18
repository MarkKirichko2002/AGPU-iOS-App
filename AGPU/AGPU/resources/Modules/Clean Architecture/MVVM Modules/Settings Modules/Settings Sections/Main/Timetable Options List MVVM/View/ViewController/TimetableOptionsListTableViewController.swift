//
//  TimetableOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import UIKit

final class TimetableOptionsListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = TimetableOptionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "clock", title: "Расписание", frame: .zero)
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
        tableView.register(UINib(nibName: TimetableOptionsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimetableOptionsTableViewCell.identifier)
        tableView.register(UINib(nibName: SaveRecentTimetableItemOptionCell.identifier, bundle: nil), forCellReuseIdentifier: SaveRecentTimetableItemOptionCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.getAllData()
        viewModel.observeOptionSelection()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = viewModel.currentOwnerScreen()
            self.navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 1:
            let vc = SavedSubGroupTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 2:
            let vc = SavedPairTypeTableViewController(type: viewModel.getSavedPairType())
            self.navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 3:
            let vc = TimeTableFavouriteItemsListTableViewController()
            vc.isSettings = true
            self.navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0,1,2,3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TimetableOptionsTableViewCell.identifier, for: indexPath) as? TimetableOptionsTableViewCell else {return UITableViewCell()}
            cell.configure(option: viewModel.options[indexPath.row])
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveRecentTimetableItemOptionCell.identifier, for: indexPath) as? SaveRecentTimetableItemOptionCell else {return UITableViewCell()}
            return cell
        default:
            return UITableViewCell()
        }
    }
}
