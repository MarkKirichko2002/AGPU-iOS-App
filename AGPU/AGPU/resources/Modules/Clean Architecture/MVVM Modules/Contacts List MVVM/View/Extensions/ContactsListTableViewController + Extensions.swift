//
//  ContactsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 05.06.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension ContactsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callNumber(number: viewModel.contactItem(index: indexPath.row).number)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updateContacts(contacts: viewModel.contacts, sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteContact(contact: viewModel.contactItem(index: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.contact = self.viewModel.contactItem(index: indexPath.row)
                self.showEditAlert()
            }
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "number")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton()
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "contacts icon")!, title: self.viewModel.contactItem(index: indexPath.row).name, text: "\(self.viewModel.contactItem(index: indexPath.row).number)")
            }
            
            return UIMenu(title: self.viewModel.contactItem(index: indexPath.row).name, children: [
                editAction,
                positionAction,
                shareAction
            ])
        }
    }
}

// MARK: - UITableViewDataSource
extension ContactsListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return viewModel.contactsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let contact = viewModel.contactItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsListTableViewCell.identifier, for: indexPath) as? ContactsListTableViewCell else {return UITableViewCell()}
        cell.configure(contact: contact)
        return cell
    }
}

extension ContactsListTableViewController {
    
    func showEditAlert() {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder =  self.viewModel.createTextForEditAlert().0
            textField.text = self.contact.name
        }
        
        alertVC.addTextField { (textField) in
            textField.placeholder =  self.viewModel.createTextForEditAlert().1
            textField.text = self.contact.number
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text, let number = alertVC.textFields![1].text {
                if !name.isEmpty {
                    self.viewModel.editContact(contact: self.contact, name: name, number: number)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
    
    @objc func showAddContactAlert() {
        
        let alertVC = UIAlertController(title: viewModel.createAddAlertMessage().0, message: viewModel.createAddAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = self.viewModel.createTextForEditAlert().0
        }
        
        alertVC.addTextField { (textField) in
            textField.placeholder = self.viewModel.createTextForEditAlert().1
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text, let number = alertVC.textFields![1].text, !name.isEmpty, !number.isEmpty {
                let model = ContactModel()
                model.id = UUID()
                model.name = name
                model.number = number
                self.viewModel.saveContact(contact: model)
            } else {
                let ok = UIAlertAction(title: "ОК", style: .default) { _ in  self.showAddContactAlert()}
                self.showAlert(title: self.viewModel.createAlertMessage().0, message: self.viewModel.createAlertMessage().1, actions: [ok])
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
}
