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
            
            return UIMenu(title: self.viewModel.optionItem(index: indexPath.row).title, children: [
                positionAction
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
