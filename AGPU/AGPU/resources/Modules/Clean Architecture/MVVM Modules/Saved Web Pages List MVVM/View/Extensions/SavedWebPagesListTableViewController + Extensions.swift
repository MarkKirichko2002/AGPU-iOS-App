//
//  SavedWebPagesListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.04.2025.
//

import UIKit

// MARK: - UITableViewDelegate
extension SavedWebPagesListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.pageItem(index: indexPath.row)
        goToWeb(url: item.url, image: "online", title: item.name, isSheet: false, isNotify: false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updatePages(pages: viewModel.pages, sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deletePage(page: viewModel.pageItem(index: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.showEditAlert(page: self.viewModel.pageItem(index: indexPath.row))
            }
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "number")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton()
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "online")!, title: self.viewModel.pageItem(index: indexPath.row).name, text: "\(self.viewModel.pageItem(index: indexPath.row).url)")
            }
            
            return UIMenu(title: self.viewModel.pageItem(index: indexPath.row).name, children: [
                editAction,
                positionAction,
                shareAction
            ])
        }
    }
}

// MARK: - UITableViewDataSource
extension SavedWebPagesListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return viewModel.pagesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let page = viewModel.pageItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedWebPagesListTableTableViewCell.identifier, for: indexPath) as? SavedWebPagesListTableTableViewCell else {return UITableViewCell()}
        cell.configure(page: page)
        return cell
    }
}

extension SavedWebPagesListTableViewController {
    
    func showEditAlert(page: WebPageModel) {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = self.viewModel.createTextForEditAlert().0
            textField.text = page.name
        }
        
        alertVC.addTextField { (textField) in
            textField.placeholder = self.viewModel.createTextForEditAlert().1
            textField.text = page.url
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text, !name.isEmpty, let url = alertVC.textFields![1].text, !url.isEmpty {
                self.viewModel.editPage(page: page, name: name)
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
    
    @objc func showAddWebPageAlert() {
        
        let alertVC = UIAlertController(title: viewModel.createAddAlertMessage().0, message: viewModel.createAddAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = self.viewModel.createTextForEditAlert().0
        }
        
        alertVC.addTextField { (textField) in
            textField.placeholder = self.viewModel.createTextForEditAlert().1
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text, !name.isEmpty, let url = alertVC.textFields![1].text, !url.isEmpty {
                let model = WebPageModel()
                model.id = UUID()
                model.name = name
                model.url = url
                self.viewModel.savePage(page: model)
            } else {
                let ok = UIAlertAction(title: "ОК", style: .default) { _ in  self.showAddWebPageAlert()}
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
