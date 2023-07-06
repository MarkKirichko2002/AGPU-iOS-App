//
//  UIViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import UIKit

extension UIViewController {
    
    func GoToWeb(url: String, title: String?) {
        let vc = WebViewController(url: url)
        if title != nil {
            vc.navigationItem.title = title
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    func ShowRecentSectionScreen(url: String) {
        let vc = RecentSectionViewController(url: url)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    func ShowAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }
}
