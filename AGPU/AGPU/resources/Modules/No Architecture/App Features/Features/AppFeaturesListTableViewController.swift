//
//  AppFeaturesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 22.07.2023.
//

import UIKit

class AppFeaturesListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Фишки"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("for student appear"), object: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "AppFeatureDetailViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AppFeatureDetailViewController") as? AppFeatureDetailViewController {
            vc.feature = AppFeaturesList.features[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
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
