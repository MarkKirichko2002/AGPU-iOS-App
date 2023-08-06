//
//  AGPUFacultiesListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2023.
//

import Foundation
import MessageUI

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
        composer.modalPresentationStyle = .fullScreen
        present(composer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
