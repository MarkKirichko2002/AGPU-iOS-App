//
//  DocumentsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 03.04.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension DocumentsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let document = viewModel.documentItem(index: indexPath.row)
        openDocument(document: document)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updateDocuments(documents: viewModel.documents, sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteDocument(document: viewModel.documentItem(index: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "document")!, title: "\(self.viewModel.documentItem(index: indexPath.row).name)", text: "\(self.viewModel.documentItem(index: indexPath.row).url)")
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.document = self.viewModel.documentItem(index: indexPath.row)
                self.showEditAlert()
            }
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "one")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton()
            }
            
            return UIMenu(title: self.viewModel.documentItem(index: indexPath.row).name, children: [
                shareAction,
                editAction,
                positionAction
            ])
        }
    }
}

// MARK: - UITableViewDataSource
extension DocumentsListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.documentsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let document = viewModel.documentItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.identifier, for: indexPath) as? DocumentTableViewCell else {return UITableViewCell()}
        cell.configure(document: document)
        return cell
    }
}

extension DocumentsListTableViewController {
    
    func showEditAlert() {
        
        let alertVC = UIAlertController(title: "Изменить документ", message: "Вы точно хотите изменить название документа?", preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите текст"
            textField.text = self.document.name
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text {
                if !name.isEmpty {
                    self.viewModel.editDocument(document: self.document, name: name)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        present(alertVC, animated: true)
    }
    
    func showAddDocumentAlert() {
        
        let alertVC = UIAlertController(title: "Добавить документ", message: "Введите URL для документа", preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите URL"
            textField.text = self.document.name
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let url = alertVC.textFields![0].text {
                if let urlPath = URL(string: url) {
                    let document = DocumentModel()
                    document.url = urlPath.absoluteString
                    document.name = urlPath.lastPathComponent
                    document.format = urlPath.pathExtension
                    document.page = 0
                    self.viewModel.addDocument(document: document)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        present(alertVC, animated: true)
    }
    
    func openDocument(document: DocumentModel) {
        if document.format == "pdf" {
            let vc = PDFDocumentReaderViewController(url: document.url)
            vc.currentPage = document.page ?? 0
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        } else {
            let vc = WordDocumentReaderViewController(url: document.url)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
    }
}
