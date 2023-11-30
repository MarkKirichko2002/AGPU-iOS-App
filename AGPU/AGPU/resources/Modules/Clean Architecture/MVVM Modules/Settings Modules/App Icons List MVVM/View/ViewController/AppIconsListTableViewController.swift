//
//  AppIconsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 10.10.2023.
//

import UIKit

class AppIconsListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = AppIconsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "photo icon", title: "Выберите иконку", frame: .zero)
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
        tableView.register(UINib(nibName: PersonalizedAppIconTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PersonalizedAppIconTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        
        viewModel.getSelectedFacultyData()
        
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.registerIconSelectedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.registerAlertHandler { title, message in
            let ok = UIAlertAction(title: "OK", style: .default)
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(ok)
            self.present(alertVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectAppIcon(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfAppIcons()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let icon = viewModel.appIconItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonalizedAppIconTableViewCell.identifier, for: indexPath) as? PersonalizedAppIconTableViewCell else {return UITableViewCell()}
        cell.PersonalizedAppIconName.textColor = viewModel.isAppIconSelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isAppIconSelected(index: indexPath.row) ? .checkmark : .none
        cell.configure(icon: icon)
        return cell
    }
}
