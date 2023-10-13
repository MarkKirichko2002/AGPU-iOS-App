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
    
    func goToWeb(url: String, image: String, title: String?, isSheet: Bool) {
        let vc = WebViewController(url: url)
        let navVC = UINavigationController(rootViewController: vc)
        if title != nil {
            let titleView = CustomTitleView(image: image, title: title ?? "", frame: .zero)
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
    
    func showRecentPageScreen(page: RecentWebPageModel) {
        let vc = RecentWebPageViewController(page: page)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(navVC, animated: true)
        }
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    func ShareImage(image: UIImage, title: String, text: String) {
        let textToShare: [Any] = [
            CustomActivityItemSource(title: title, text: text, image: image, type: .image)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true)
        }
    }
    
    func shareInfo(image: UIImage, title: String, text: String) {
        let textToShare: [Any] = [
            CustomActivityItemSource(title: title, text: text, image: image, type: .url)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true)
        }
    }
    
    func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    func sendScreenWasClosedNotification() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
        }
    }
    
    func checkForUpdates() {
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let appStoreURL = URL(string: "your_app_store_url_here"),
           let appStoreVersion = getAppStoreVersion(url: appStoreURL)
        {
            if currentVersion != appStoreVersion {
                showUpdateAlert()
            }
        }
    }
    
    func getAppStoreVersion(url: URL) -> String? {
        do {
            let appStoreInfo = try String(contentsOf: url)
            let pattern = "\"version\":\"([^\"]*)\""
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let result = regex.firstMatch(in: appStoreInfo, options: .init(rawValue: 0), range: NSRange(location: 0, length: appStoreInfo.utf16.count))
            
            if let range = Range(result!.range(at: 1), in: appStoreInfo) {
                return String(appStoreInfo[range])
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func showUpdateAlert() {
        let alert = UIAlertController(title: "Обновление доступно",
                                      message: "Обнаружено новое обновление. Хотите обновить приложение сейчас?",
                                      preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Обновить", style: .default) { _ in
            if let appStoreURL = URL(string: "your_app_store_url_here") {
                UIApplication.shared.open(appStoreURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
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
    
    func playVideo(url: String) {
        
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
