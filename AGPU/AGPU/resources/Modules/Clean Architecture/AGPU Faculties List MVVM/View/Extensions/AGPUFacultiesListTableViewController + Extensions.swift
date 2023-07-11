//
//  AGPUFacultiesListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2023.
//

import Foundation
import MessageUI
import AVKit

// MARK: - MFMailComposeViewControllerDelegate
extension AGPUFacultiesListTableViewController: MFMailComposeViewControllerDelegate {
    
    func showEmailComposer(email: String) {
        
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([email])
        composer.setSubject("Тема письма")
        composer.setMessageBody("Текст письма", isHTML: false)
        
        present(composer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - AVPlayerViewControllerDelegate
extension AGPUFacultiesListTableViewController: AVPlayerViewControllerDelegate {
    
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
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
            completionHandler(true)
        }
    }
}
