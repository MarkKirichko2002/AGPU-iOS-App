//
//  SplashScreensListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 04.01.2024.
//

import UIKit

class SplashScreensListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = SplashScreensListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Выберите экран заставки"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        sendScreenWasClosedNotification()
        dismiss(animated: true)
    }

    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        
        viewModel.registerSplashScreenOptionSelectedHandler {
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
        viewModel.chooseSplashScreenOption(index: indexPath.row)
        if SplashScreenOptions.allCases[indexPath.row] == .custom {
            let vc = CustomSplashScreenEditorViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SplashScreenOptions.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = SplashScreenOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isCurrentSplashScreenOption(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isCurrentSplashScreenOption(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
