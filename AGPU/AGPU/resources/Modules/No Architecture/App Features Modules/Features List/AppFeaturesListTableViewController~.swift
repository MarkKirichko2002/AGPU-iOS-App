//
//  AppFeaturesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 22.07.2023.
//

import UIKit

final class AppFeaturesListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "info icon", title: "Фишки", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(feature.id)) \(feature.name)"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
