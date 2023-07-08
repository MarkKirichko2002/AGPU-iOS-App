//
//  UIViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import UIKit

extension UIViewController {
    
    func GoToWeb(url: String, title: String?) {
        UserDefaults.standard.setValue(url, forKey: "last page")
        let vc = WebViewController(url: url)
        if title != nil {
            vc.navigationItem.title = title
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    func ShowRecentPageScreen(page: RecentPageModel) {
        let vc = RecentPageViewController(url: page.url)
        let navVC = UINavigationController(rootViewController: vc)
        vc.navigationItem.title = page.date
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
