//
//  CurrentTabFavouriteOptionsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension CurrentTabFavouriteOptionsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = viewModel.createTextInfoForOption(option: viewModel.optionItem(index: indexPath.row))
        self.showAlert(title: info.0, message: info.1, actions: [UIAlertAction(title: "ОК", style: .default)])
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updateOptions(options: viewModel.options, sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "number")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton(title: "Готово")
            }
            
            let editName = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.showEditOptionAlert(option: self.viewModel.optionItem(index: indexPath.row))
            }
            
            return UIMenu(title: self.viewModel.optionItem(index: indexPath.row).title, children: [
                positionAction,
                editName
            ])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let option = viewModel.optionItem(index: indexPath.row)
            viewModel.deleteOption(option: option)
        }
    }
}

// MARK: - UITableViewDataSource
extension CurrentTabFavouriteOptionsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shortcut = viewModel.optionItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shortcut.title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}

// MARK: - CurrentTabOptionsListTableViewController
extension CurrentTabFavouriteOptionsListViewController: CurrentTabOptionsListTableViewControllerDelegate {
    func optionWasAdded() {
        viewModel.getOptions()
    }
}

extension CurrentTabFavouriteOptionsListViewController {
    
    func showEditOptionAlert(option: TabOptionModel) {
        
        let alertVC = UIAlertController(title: viewModel.createEditAlertMessage().0, message: viewModel.createEditAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Название"
            textField.text = option.title
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text {
                if !name.isEmpty {
                    if name.count <= 15 {
                        self.viewModel.editText(option: option, text: name)
                    } else {
                        self.showAlert(title: "Слишком много текста!", message: "Количество символов не должно превышать 15", actions: [UIAlertAction(title: "ОК", style: .default) { _ in self.showEditOptionAlert(option: option)}])
                    }
                }
            }
        }
        
        let resetsaveAction = UIAlertAction(title: "Сбросить", style: .destructive) { _ in
            self.viewModel.resetTitle(option: option)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .default) { _ in}
        
        alertVC.addAction(saveAction)
        alertVC.addAction(resetsaveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
}
