//
//  AppFeaturesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 22.07.2023.
//

import UIKit
import SafariServices

final class AppFeaturesListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "info icon", title: "Фишки приложения", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setUpTable() {
        tableView.register(AppFeaturesListTableViewCell.self, forCellReuseIdentifier: AppFeaturesListTableViewCell.identifier)
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        self.dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "AppFeatureDetailViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AppFeatureDetailViewController") as? AppFeatureDetailViewController {
            vc.feature = AppFeaturesList.features[indexPath.row]
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppFeaturesList.features.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feature = AppFeaturesList.features[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppFeaturesListTableViewCell.identifier, for: indexPath) as? AppFeaturesListTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.configure(feature: feature)
        return cell
    }
}

// MARK: - IAppFeaturesListTableViewCell
extension AppFeaturesListTableViewController: IAppFeaturesListTableViewCell {
    
    func infoWasTapped() {
        guard let url = URL(string: "https://www.youtube.com/watch?v=u-n5iBWaOWQ") else {return}
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true)
    }
}
