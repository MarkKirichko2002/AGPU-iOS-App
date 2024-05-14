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
        let titleView = CustomTitleView(image: "mobile", title: "Экраны заставки", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        navigationItem.titleView = titleView
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        dismiss(animated: true)
    }

    private func setUpTable() {
        tableView.register(SplashScreenTableViewCell.self, forCellReuseIdentifier: SplashScreenTableViewCell.identifier)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SplashScreenTableViewCell.identifier, for: indexPath) as? SplashScreenTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        let screen = SplashScreenOptions.allCases[indexPath.row]
        cell.configure(screen: screen, viewModel: viewModel)
        return cell
    }
}

// MARK: - ISplashScreenTableViewCell
extension SplashScreensListTableViewController: ISplashScreenTableViewCell {
    
    func infoWasTapped(video: String) {
        self.playLocalVideo(video: video)
    }
}
