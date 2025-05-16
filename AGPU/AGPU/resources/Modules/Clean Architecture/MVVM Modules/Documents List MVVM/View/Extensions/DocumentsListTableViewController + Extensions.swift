//
//  DocumentsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 03.04.2024.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

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
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.document = self.viewModel.documentItem(index: indexPath.row)
                self.showEditAlert()
            }
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "number")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton()
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                let activityViewController = UIActivityViewController(activityItems: [URL(string: self.viewModel.documentItem(index: indexPath.row).url)!], applicationActivities: nil)
                self.present(activityViewController, animated: true)
            }
            
            return UIMenu(title: self.viewModel.documentItem(index: indexPath.row).name, children: [
                editAction,
                positionAction,
                shareAction
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

// MARK: - UIDocumentPickerDelegate
extension DocumentsListTableViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        print(sandboxFileURL)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            do {
                try FileManager.default.removeItem(at: sandboxFileURL)
                print("copied file")
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                self.viewModel.addDocumentFromFiles(url: sandboxFileURL)
            } catch {
                print(error)
            }
        } else {
            do {
                print("copied file")
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                self.viewModel.addDocumentFromFiles(url: sandboxFileURL)
            } catch {
                print(error)
            }
        }
    }
}

extension DocumentsListTableViewController {
    
    func showEditAlert() {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Название"
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
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
    
    func showChooseDocumentAlert() {
        
        let documentsAction = UIAlertAction(title: "Файлы", style: .default) { _ in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.present(documentPicker, animated: true)
        }
        
        let URLAction = UIAlertAction(title: "URL", style: .default) { _ in
            self.showAddDocumentURLAlert()
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        self.showAlert(title: "Добавление документа", message: "каким образом добавить документ?", actions: [documentsAction, URLAction, cancel])
    }
    
    func showAddDocumentURLAlert() {
        
        let alertVC = UIAlertController(title: viewModel.createTextForEditAlert().0, message: viewModel.createTextForEditAlert().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "URL"
            textField.text = self.document.name
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let url = alertVC.textFields![0].text {
                if let urlPath = URL(string: url) {
                    self.viewModel.addDocument(by: urlPath)
                } else {
                    let ok = UIAlertAction(title: "ОК", style: .default) { _ in  self.showAddDocumentURLAlert()}
                    self.showAlert(title: self.viewModel.createAlertMessage().0, message: self.viewModel.createAlertMessage().1, actions: [ok])
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
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
            HapticsManager.shared.hapticFeedback()
        } else if document.format == "txt" {
            let storyboard = UIStoryboard(name: "TextFileDetailViewController", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "TextFileDetailViewController") as? TextFileDetailViewController {
                vc.document = document
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                    self.present(navVC, animated: true)
                }
            }
            HapticsManager.shared.hapticFeedback()
        } else {
            let vc = WordDocumentReaderViewController(url: document.url)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
            HapticsManager.shared.hapticFeedback()
        }
    }
}
