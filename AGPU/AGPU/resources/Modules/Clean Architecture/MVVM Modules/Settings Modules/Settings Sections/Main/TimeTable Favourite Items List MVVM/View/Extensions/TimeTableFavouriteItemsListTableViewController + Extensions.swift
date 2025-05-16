//
//  TimeTableFavouriteItemsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension TimeTableFavouriteItemsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.favouriteItem(index: indexPath.row)
        if !isSettings {
            delegate?.WasSelected(result: item)
            HapticsManager.shared.hapticFeedback()
            self.dismiss(animated: true)
        } else {
            let date = DateManager().getCurrentDate()
            let vc = CurrentDateTimeTableDayListTableViewController(id: item.name, date: date, owner: item.owner)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.updateItems(items: viewModel.items, sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = viewModel.favouriteItem(index: indexPath.row)
            viewModel.deleteItem(item: item)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let positionAction = UIAction(title: "Позиция", image: UIImage(named: "number")) { _ in
                tableView.isEditing.toggle()
                self.setUpEditButton()
            }
            
            return UIMenu(title: self.viewModel.favouriteItem(index: indexPath.row).name, children: [
                positionAction
            ])
        }
    }
}

// MARK: - UITableViewDataSource
extension TimeTableFavouriteItemsListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.favouriteItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableFavouriteItemTableViewCell.identifier, for: indexPath) as? TimeTableFavouriteItemTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.configure(item: item)
        return cell
    }
}

// MARK: - ITimeTableFavouriteItemTableViewCell
extension TimeTableFavouriteItemsListTableViewController: ITimeTableFavouriteItemTableViewCell {
    
    func itemWasSelected(item: SearchTimetableModel) {
        let date = DateManager().getCurrentDate()
        let vc = CurrentDateTimeTableDayListTableViewController(id: item.name, date: date, owner: item.owner)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

// MARK: - TimeTableSearchListTableViewControllerDelegate
extension TimeTableFavouriteItemsListTableViewController: TimeTableSearchListTableViewControllerDelegate {
    
    func itemWasSelected(result: SearchTimetableModel) {
        viewModel.getItems()
    }
}
