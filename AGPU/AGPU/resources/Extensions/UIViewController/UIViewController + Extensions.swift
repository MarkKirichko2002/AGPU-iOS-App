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
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
        }
    }
    
    func ShowRecentPageScreen(page: RecentPageModel) {
        let vc = RecentWebPageViewController(page: page)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
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
        
        let image = tableView.toImage()!
        
        let textToShare: [Any] = [
            CustomActivityItemSource(title: title, text: text, image: image, type: .image)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    func shareInfo(image: UIImage, title: String, text: String) {
        let textToShare: [Any] = [
            CustomActivityItemSource(title: title, text: text, image: image, type: .url)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL)
            }
        }
    }
}
