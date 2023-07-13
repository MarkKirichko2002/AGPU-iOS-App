//
//  UIViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import UIKit

extension UIViewController {
    
    func GoToWeb(url: String, title: String?, isSheet: Bool) {
        let vc = WebViewController(url: url)
        let navVC = UINavigationController(rootViewController: vc)
        if title != nil {
            vc.navigationItem.title = title
        }
        if isSheet {
            present(navVC, animated: true)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func ShowRecentPageScreen(page: RecentPageModel) {
        let vc = RecentPageViewController(url: page.url)
        let navVC = UINavigationController(rootViewController: vc)
        vc.navigationItem.title = "\(page.date) \(page.time)"
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
