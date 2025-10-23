//
//  FavouriteShortcutsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 07.12.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension FavouriteShortcutsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = viewModel.createTextInfoForShortcut(shortcut: viewModel.shortcutItem(index: indexPath.row))
        self.showAlert(title: info.0, message: info.1, actions: [UIAlertAction(title: "ОК", style: .default)])
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updateShortcuts(shortcuts: viewModel.shortcuts, sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let info = self.viewModel.createTextInfoForShortcut(shortcut: self.viewModel.shortcutItem(index: indexPath.row))
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.showEditAlert(shortcut: self.viewModel.shortcutItem(index: indexPath.row))
            }
            
            let switchName =  UIAction(title: "Заменить", image: UIImage(named: "replace")) { _ in
                self.showSwitchItemAlert(info: info, shortcut: self.viewModel.shortcutItem(index: indexPath.row))
            }
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "number")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton(title: "Готово")
            }
            
            return UIMenu(title: info.0, children: [
                editAction,
                switchName,
                positionAction
            ])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let shortcut = viewModel.shortcutItem(index: indexPath.row)
            viewModel.deleteShortcut(shortcut: shortcut)
        }
    }
}

// MARK: - UITableViewDataSource
extension FavouriteShortcutsListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shortcutsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shortcut = viewModel.shortcutItem(index: indexPath.row)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = shortcut.title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = shortcut.subtitle
        cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}

// MARK: - AllShortcutsListTableViewControllerDelegate
extension FavouriteShortcutsListTableViewController: AllShortcutsListTableViewControllerDelegate {
    
    func shortcutWasAdded() {
        viewModel.getShortcuts()
    }
}

// MARK: - FavouriteTitlesListTableViewControllerDelegate
extension FavouriteShortcutsListTableViewController: FavouriteTitlesListTableViewControllerDelegate {
    
    func titleWasSelected(title: String) {
        viewModel.updateShortcutTitle(title: title)
    }
}

// MARK: - FavouriteDescriptionsListTableViewControllerDelegate
extension FavouriteShortcutsListTableViewController: FavouriteDescriptionsListTableViewControllerDelegate {
    
    func descriptionWasSelected(description: String) {
        viewModel.updateShortcutDescription(description: description)
    }
}

extension FavouriteShortcutsListTableViewController {
    
    func showSwitchItemAlert(info: (String, String), shortcut: ShortcutModel) {
        
        let titleAction = UIAlertAction(title: "Название", style: .default) { _ in
            let vc = FavouriteTitlesListTableViewController(name: info.0)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.viewModel.currentShortCut = shortcut
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.present(navVC, animated: true)
            }
        }
        let descriptionAction = UIAlertAction(title: "Описание", style: .default) { _ in
            let vc = FavouriteDescriptionsListTableViewController(name: info.0)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.viewModel.currentShortCut = shortcut
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.present(navVC, animated: true)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        self.showAlert(title: "Что нужно заменить для шортката?", message: "", actions: [titleAction, descriptionAction, cancel])
    }
    
    func showEditAlert(shortcut: ShortcutModel) {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder =  self.viewModel.createTextForEditAlert().0
            textField.text = shortcut.title
        }
        
        alertVC.addTextField { (textField) in
            textField.placeholder = self.viewModel.createTextForEditAlert().1
            textField.text = shortcut.subtitle
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let title = alertVC.textFields![0].text, let subttile = alertVC.textFields![1].text {
                if !title.isEmpty {
                    if title.count > 40 {
                        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
                            self.showEditAlert(shortcut: shortcut)
                        }
                        self.showAlert(title: "Слишком много символов у названия!", message: "можно ввести не более 40 включая пробелы", actions: [ok])
                    } else if subttile.count > 43 {
                        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
                            self.showEditAlert(shortcut: shortcut)
                        }
                        self.showAlert(title: "Слишком много символов у описания!", message: "можно ввести не более 43 включая пробелы", actions: [ok])
                    } else {
                        var model = shortcut
                        model.title = title
                        model.subtitle = subttile
                        self.viewModel.updateShortcutInfo(shortcut: model)
                    }
                    print(subttile.count)
                }
            }
        }
        
        let reset = UIAlertAction(title: "Сбросить", style: .destructive) { _ in
            self.viewModel.resetShortcut(shortcut: shortcut)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .default)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(reset)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
}
