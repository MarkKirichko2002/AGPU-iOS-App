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
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "contacts icon")!, title: self.viewModel.contactItem(index: indexPath.row).name, text: "\(self.viewModel.contactItem(index: indexPath.row).number)")
            }
            
            return UIMenu(title: self.viewModel.contactItem(index: indexPath.row).name, children: [
                editAction,
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
        
        let alertVC = UIAlertController(title: "Изменить контакт", message: "Вы точно хотите изменить данные контакта?", preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите имя"
            textField.text = self.contact.name
        }
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите номер"
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
        
        present(alertVC, animated: true)
    }
    
    @objc func showAddContactAlert() {
        
        let alertVC = UIAlertController(title: "Добавить контакт", message: "Введите данные для контакта", preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите имя"
        }
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите номер"
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
                self.showAlert(title: "Вы не ввели данные!", message: "Введите данные для контакта", actions: [ok])
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        present(alertVC, animated: true)
    }
}
