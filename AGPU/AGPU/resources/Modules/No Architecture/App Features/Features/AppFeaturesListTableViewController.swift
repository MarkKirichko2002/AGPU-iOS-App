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
        SetUpNavigation()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("for student appear"), object: nil)
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Фишки"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
         dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "AppFeatureDetailViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AppFeatureDetailViewController") as? AppFeatureDetailViewController {
            vc.feature = AppFeaturesList.features[indexPath.row]
            let navVC = UINavigationController(rootViewController: vc)
            self.present(navVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppFeaturesList.features.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)) \(AppFeaturesList.features[indexPath.row].name)"
        return cell
    }
}
