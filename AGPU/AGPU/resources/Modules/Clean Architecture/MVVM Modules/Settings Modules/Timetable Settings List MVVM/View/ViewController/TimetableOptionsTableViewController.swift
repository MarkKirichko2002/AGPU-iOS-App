//
//  TimetableOptionsTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import UIKit

class TimetableOptionsTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = TimetableSettingsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "clock", title: "Расписание", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: TimetableOptionsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimetableOptionsTableViewCell.identifier)
        tableView.register(UINib(nibName: SaveRecentTimetableItemOptionCell.identifier, bundle: nil), forCellReuseIdentifier: SaveRecentTimetableItemOptionCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.getAllData()
        viewModel.observeOptionSelection()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.hapticFeedback()
        switch indexPath.row {
        case 0:
            if let faculty = viewModel.getSavedFaculty() {
                let vc = FacultyGroupsListTableViewController(faculty: faculty)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            let vc = SavedSubGroupTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = SavedPairTypeTableViewController(type: viewModel.getSavedPairType())
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0,1,2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TimetableOptionsTableViewCell.identifier, for: indexPath) as? TimetableOptionsTableViewCell else {return UITableViewCell()}
            cell.configure(option: viewModel.options[indexPath.row])
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveRecentTimetableItemOptionCell.identifier, for: indexPath) as? SaveRecentTimetableItemOptionCell else {return UITableViewCell()}
            return cell
        }
    }
}
