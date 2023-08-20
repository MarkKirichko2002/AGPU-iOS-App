//
//  UIViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import UIKit
import AVKit
import MessageUI

extension UIViewController {
    
    func GoToWeb(url: String, title: String?, isSheet: Bool) {
        let vc = WebViewController(url: url)
        let navVC = UINavigationController(rootViewController: vc)
        if title != nil {
            let titleView = CustomTitleView(image: "online", title: title ?? "", frame: .zero)
            vc.navigationItem.titleView = titleView
        }
        if isSheet {
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        } else {
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
    }
    
    func ShowRecentPageScreen(page: RecentWebPageModel) {
        let vc = RecentWebPageViewController(page: page)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(navVC, animated: true)
        }
    }
    
    func ShowAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
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
    
    func OpenSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL)
            }
        }
    }
    
    func SetUpSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
        }
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension UIViewController: MFMailComposeViewControllerDelegate {
    
    func showEmailComposer(email: String) {
        
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([email])
        composer.setSubject("Тема письма")
        composer.setMessageBody("Текст письма", isHTML: false)
        composer.modalPresentationStyle = .fullScreen
        present(composer, animated: true, completion: nil)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - AVPlayerViewControllerDelegate
extension UIViewController: AVPlayerViewControllerDelegate {
    
    func PlayVideo(url: String) {
        guard let videoURL = URL(string: url) else {
            print("Invalid video URL")
            return
        }
        
        // Создаем AVPlayerViewController
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        playerViewController.delegate = self
        // Воспроизводим видео
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
        UserDefaults.standard.setValue(url, forKey: "last video")
    }
    
    public func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
            completionHandler(true)
        }
    }
}
