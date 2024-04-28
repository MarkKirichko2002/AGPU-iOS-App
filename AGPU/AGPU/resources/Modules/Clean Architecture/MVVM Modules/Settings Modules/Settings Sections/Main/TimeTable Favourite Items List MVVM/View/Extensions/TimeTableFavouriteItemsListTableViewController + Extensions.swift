//
//  TimeTableFavouriteItemsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import UIKit

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
    
    func itemWasSelected() {
        viewModel.getItems()
    }
}
