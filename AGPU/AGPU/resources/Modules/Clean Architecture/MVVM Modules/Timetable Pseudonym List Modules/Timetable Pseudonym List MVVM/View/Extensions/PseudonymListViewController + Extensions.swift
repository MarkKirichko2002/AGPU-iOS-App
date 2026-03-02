//
//  PseudonymListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 14.10.2025.
//

import UIKit

// MARK: - UITableViewDelegate
extension PseudonymListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let pseudonym = self.viewModel.pseudonymItem(index: indexPath.row)
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.showEditAlert(model: pseudonym)
            }
            
            return UIMenu(title: pseudonym.originalName, children: [
                editAction
            ])
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = viewModel.pseudonymItem(index: indexPath.row)
            viewModel.deletePseudonym(model: model)
            self.delegate?.listWasChanged()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updatePseudonyms(sourceIndexPath.row, destinationIndexPath.row)
        }
    }
}

// MARK: - UITableViewDataSource
extension PseudonymListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPseudonyms()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pseudonym = viewModel.pseudonymItem(index: indexPath.row)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = pseudonym.originalName
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = pseudonym.pseudonym
        cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}

extension PseudonymListViewController {
    
    func showEditAlert(model: PseudonymModel) {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder =  self.viewModel.createEditAlertMessage().0
            textField.text = model.pseudonym
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let pseudonym = alertVC.textFields![0].text {
                if !pseudonym.isEmpty {
                    self.viewModel.editPseudonym(model: model, pseudonym: pseudonym)
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
