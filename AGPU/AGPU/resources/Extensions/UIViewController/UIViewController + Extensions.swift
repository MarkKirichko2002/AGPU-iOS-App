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
        let vc = RecentPageViewController(page: page)
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
    
    func shareTableViewAsImage(tableView: UITableView, title: String, text: String) {
        
        let renderer = UIGraphicsImageRenderer(bounds: tableView.bounds)
        
        let image = renderer.image { context in
            tableView.drawHierarchy(in: tableView.bounds, afterScreenUpdates: true)
        }
        let textToShare: [Any] = [
            CustomActivityItemSource(title: title, text: text, image: image),
            image
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
