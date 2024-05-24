//
//  AppFeaturesListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 24.05.2024.
//

import SafariServices

// MARK: - IAppFeaturesListTableViewCell
extension AppFeaturesListTableViewController: IAppFeaturesListTableViewCell {
    
    func infoWasTapped(url: String) {
        guard let url = URL(string: url) else {return}
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true)
    }
}
