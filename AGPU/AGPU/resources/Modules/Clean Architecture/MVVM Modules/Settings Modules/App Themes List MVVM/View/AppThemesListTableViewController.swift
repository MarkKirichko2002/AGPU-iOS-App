//
//  AppThemesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 22.09.2023.
//

import UIKit

class AppThemesListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = AppThemesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "theme", title: "Выберите тему", frame: .zero)
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerThemeSelectedHandler { theme in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            UIView.transition(with: self.view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.view.window?.overrideUserInterfaceStyle = theme
            }, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectTheme(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let themes = AppThemes.themes
        return themes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = viewModel.themeItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = theme.name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.tintColor = .systemGreen
        cell.accessoryType = viewModel.isThemeSelected(index: indexPath.row) ? .checkmark : .none
        cell.textLabel?.textColor = viewModel.isThemeSelected(index: indexPath.row) ? .systemGreen : .label
        return cell
    }
}
