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
    
    func goToWeb(url: String, image: String, title: String?, isSheet: Bool, isNotify: Bool) {
        let vc = WebViewController(url: url, isNotify: isNotify)
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
        let isVisualChanges = UserDefaults.standard.object(forKey: "onVisualChanges") as? Bool ?? false
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let appStoreURL = URL(string: "https://itunes.apple.com/lookup?id=6458836690")
        {
            getAppStoreVersion(url: appStoreURL) { (appStoreVersion) in
                if let appStoreVersion = appStoreVersion {
                    print(appStoreVersion)
                    if currentVersion != appStoreVersion {
                        if !isVisualChanges {
                            DispatchQueue.main.async {
                                self.showUpdateAlert()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getAppStoreVersion(url: URL, completion: @escaping (String?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Data retrieval error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let results = json["results"] as! [[String: Any]]
                
                if let appStoreVersion = results.first?["version"] as? String {
                    print("App Store version: \(appStoreVersion)")
                    completion(appStoreVersion)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
            }
        }.resume()

    }
    
    func showUpdateAlert() {
        let vc = AppUpdateAlertViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func showNoVideoAlert() {
        let ok = UIAlertAction(title: "ОК", style: .default)
        self.showAlert(title: "Видео отсутствует", message: "У данного экрана заставки нет видео", actions: [ok])
    }
    
    func showHintAlert(type: Hints) {
        
        let ok = UIAlertAction(title: "ОК", style: .default) { _ in}
        
        switch type {
            
        case .faculty:
            let vc = HintViewController(info: "Чтобы вызвать контекстное меню удерживайте ячейку факультета")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .cathedra:
            let vc = HintViewController(info: "Чтобы вызвать контекстное меню удерживайте ячейку кафедры")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .manuals:
            let vc = HintViewController(info: "Чтобы посмотреть методические материалы для вашей кафедры выберите ее в настройках")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .additionalEducation:
            let vc = HintViewController(info: "Чтобы посмотреть соответствующие материалы для вашей кафедры выберите ее в настройках")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    @objc func showWhatsNewVC() {
        let vc = TodayNewsListTableViewController()
        let navVC = UINavigationController(rootViewController: vc)
        let style = UserDefaults.loadData(type: ScreenPresentationStyles.self, key: "screen presentation style") ?? .notShow
        switch style {
        case .fullScreen:
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
        case .sheet:
            navVC.modalPresentationStyle = .pageSheet
            present(navVC, animated: true)
        case .notShow:
            let vc = HintViewController(info: "Чтобы увидеть экран, выберите его отображение в настройках опции \"Наглядные изменения\"")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
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
    
    func playLocalVideo(video: String) {
        if video != "" {
            guard let path = Bundle.main.path(forResource: video, ofType: "mp4") else {return print("не работает")}
            let videoURL = URL(fileURLWithPath: path)
            // Создаем AVPlayerViewController
            let playerViewController = AVPlayerViewController()
            let player = AVPlayer(url: videoURL)
            playerViewController.player = player
            playerViewController.delegate = self
            // Воспроизводим видео
            present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
            UserDefaults.standard.setValue(video, forKey: "last video")
        } else {
            showNoVideoAlert()
        }
    }
    
    public func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
            completionHandler(true)
        }
    }
}
