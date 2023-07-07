//
//  SettingsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.06.2023.
//

import UIKit
import MessageUI

// MARK: - UITableViewDataSource
extension SettingsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRowAt(tableView: tableView, indexPath: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension SettingsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.HeaderForView(in: section, view: self.view)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            switch indexPath.section {
                
            case 0:
                let playAction = UIAction(title: "воспроизвести", image: UIImage(named: "play")) { action in
                    self.viewModel.OnMusic(index: indexPath.row)
                }
                let pauseAction = UIAction(title: "пауза", image: UIImage(named: "pause")) { action in
                    self.viewModel.OffMusic(index: indexPath.row)
                }
                let restartAction = UIAction(title: "заново", image: UIImage(named: "restart")) { action in
                    self.viewModel.RestartMusic(index: indexPath.row)
                }
                let deleteAction = UIAction(title: "удалить", image: UIImage(named: "trash")) { action in
                    self.viewModel.DeleteMusic(index: indexPath.row)
                }
                return UIMenu(title: self.viewModel.musicItem(index: indexPath.row).name, children: [playAction, pauseAction, restartAction, deleteAction])
                
            case 1:
                let infoAction = UIAction(title: "узнать больше", image: UIImage(named: "info")) { action in
                    self.GoToWeb(url: self.viewModel.electedFacultyItem(index: indexPath.row).url, title: "Факультет")
                }
                
                let phoneAction = self.viewModel.makePhoneNumbersMenu(index: indexPath.row)
                
                let emailAction = UIAction(title: "написать", image: UIImage(named: "mail")) { action in
                    self.showEmailComposer(email: self.viewModel.electedFacultyItem(index: indexPath.row).email)
                }
                
                let iconAction = UIAction(title: "выбрать иконку", image: UIImage(named: "photo")) { action in
                    self.viewModel.ChangeIcon(index: indexPath.row)
                }
                
                let enterAction = UIAction(title: "поступить", image: UIImage(named: "worksheet")) { action in
                    self.GoToWeb(url: "http://priem.agpu.net/anketa/index.php", title: "Анкета")
                }
                
                return UIMenu(title: self.viewModel.electedFacultyItem(index: indexPath.row).name, children: [infoAction, emailAction, phoneAction, enterAction, iconAction])
                
            default:
                return nil
            }
        })
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 0:
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                self.viewModel.DeleteMusic(index: indexPath.row)
            }
            deleteAction.image = UIImage(systemName: "trash")
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.DidSelectRow(at: indexPath)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingsListViewController: MFMailComposeViewControllerDelegate {
    
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
