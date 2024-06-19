//
//  TimetableDateDetailViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.06.2024.
//

import UIKit

// MARK: - TimeTableSearchListTableViewControllerDelegate
extension TimetableDateDetailViewController: TimeTableSearchListTableViewControllerDelegate {
    
    func itemWasSelected(result: SearchTimetableModel) {
        viewModel.getTimeTableForSearch(id: result.name, owner: result.owner)
    }
}

// MARK: - AllGroupsListTableViewControllerDelegate
extension TimetableDateDetailViewController: AllGroupsListTableViewControllerDelegate {
    
    func groupWasSelected(group: String) {
        viewModel.getTimeTableForSearch(id: group, owner: "GROUP")
    }
}

// MARK: - SubGroupsListTableViewControllerDelegate
extension TimetableDateDetailViewController: SubGroupsListTableViewControllerDelegate {
    
    func subGroupWasSelected(subgroup: Int) {
        viewModel.filterPairs(by: subgroup)
    }
}

// MARK: - TimeTableFavouriteItemsListTableViewControllerDelegate
extension TimetableDateDetailViewController: TimeTableFavouriteItemsListTableViewControllerDelegate {
    
    func WasSelected(result: SearchTimetableModel) {
        viewModel.getTimeTableForSearch(id: result.name, owner: result.owner)
    }
}

// MARK: - PairTypesListTableViewControllerDelegate
extension TimetableDateDetailViewController: PairTypesListTableViewControllerDelegate {
    
    func pairTypeWasSelected(type: PairType) {
        viewModel.filterPairs(type: type)
    }
}

extension TimetableDateDetailViewController {
    
    func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить в фото", style: .default) { _ in
            guard let image = self.viewModel.image else {return}
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: image)
        }
        
        let saveAction2 = UIAlertAction(title: "Сохранить в \"Важные вещи\"", style: .default) { _ in
            self.viewModel.saveImageToList()
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: "Сохранить расписание?", message: "Вы хотите сохранить изображение расписания?", actions: [saveAction2, saveAction, cancel])
    }
}
