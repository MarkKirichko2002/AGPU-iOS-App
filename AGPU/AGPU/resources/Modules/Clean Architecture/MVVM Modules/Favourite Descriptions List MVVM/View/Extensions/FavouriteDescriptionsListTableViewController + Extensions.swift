//
//  FavouriteDescriptionsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.09.2025.
//

import UIKit

// MARK: - UITableViewDelegate
extension FavouriteDescriptionsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.descriptionWasSelected(description: viewModel.descriptionItem(index: indexPath.row))
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.dismiss(animated: true)
        }
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updateDescriptions(descriptions: viewModel.descriptions, sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.showEditAlert(title: self.viewModel.descriptionItem(index: indexPath.row))
            }
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "number")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton(title: "Готово")
            }
            
            return UIMenu(title: self.viewModel.descriptionItem(index: indexPath.row), children: [
                editAction,
                positionAction
            ])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let description = viewModel.descriptionItem(index: indexPath.row)
            viewModel.deleteDescription(description: description)
        }
    }
}

// MARK: - UITableViewDataSource
extension FavouriteDescriptionsListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.descriptionsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = viewModel.descriptionItem(index: indexPath.row)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

extension FavouriteDescriptionsListTableViewController {
    
    func showAddTitleAlert() {
        
        let alertVC = UIAlertController(title: viewModel.createAddAlertMessage().0, message: viewModel.createAddAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = self.viewModel.createAddAlertMessage().0
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text, !name.isEmpty {
                if name.count > 43 {
                    let ok = UIAlertAction(title: "ОК", style: .default) { _ in
                        self.showAddTitleAlert()
                    }
                    self.showAlert(title: "Слишком много символов у описания!", message: "можно ввести не более 43 включая пробелы", actions: [ok])
                } else {
                    self.viewModel.addDescription(description: name)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
    
    func showEditAlert(title: String) {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder =  self.viewModel.createEditAlertMessage().0
            textField.text = title
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text {
                if !name.isEmpty {
                    if title.count > 43 {
                        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
                            self.showEditAlert(title: title)
                        }
                        self.showAlert(title: "Слишком много символов у описания!", message: "можно ввести не более 43 включая пробелы", actions: [ok])
                    } else {
                        self.viewModel.updateDescriptionInfo(description: title, name: name)
                    }
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
}

