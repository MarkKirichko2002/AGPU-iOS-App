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

// MARK: - NearBuildingViewControllerDelegate
extension TimetableDateDetailViewController: NearBuildingViewControllerDelegate {
    
    func audienceSelected(audience: String) {
        viewModel.getTimeTableForSearch(id: audience, owner: "CLASSROOM")
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

// MARK: - DepartmentsListTableViewControllerDelegate
extension TimetableDateDetailViewController: DepartmentsListTableViewControllerDelegate {
    
    func teacherSelected(teacher: String) {
        viewModel.getTimeTableForSearch(id: teacher, owner: "TEACHER")
    }
}

// MARK: - CorpsListTableViewControllerDelegate
extension TimetableDateDetailViewController: CorpsListTableViewControllerDelegate {
    
    func audienceWasSelected(audience: String) {
        viewModel.getTimeTableForSearch(id: audience, owner: "CLASSROOM")
    }
}

// MARK: - TimeTableFavouriteItemsListTableViewControllerDelegate
extension TimetableDateDetailViewController: TimeTableFavouriteItemsListTableViewControllerDelegate {
    
    func WasSelected(result: SearchTimetableModel) {
        viewModel.getTimeTableForSearch(id: result.name, owner: result.owner)
    }
}

// MARK: - TimetableFilterCategoriesListTableViewControllerDelegate
extension TimetableDateDetailViewController: TimetableFilterCategoriesListTableViewControllerDelegate {
    
    func timeWasSelected(time: String) {
        viewModel.filterPairs(by: time)
    }
    
    func pairTypeWasSelected(type: PairType) {
        viewModel.filterPairs(type: type)
    }
    
    func buildingWasSelected(building: AGPUBuildingModel) {
        viewModel.filterPairs(by: building)
    }
}

extension TimetableDateDetailViewController {
    
    func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить в фото", style: .default) { _ in
            guard let image = self.viewModel.image else {return}
            self.imageSaver.writeToPhotoAlbum(image: image)
        }
        
        let saveAction2 = UIAlertAction(title: "Сохранить в \"Важные вещи\"", style: .default) { _ in
            self.viewModel.saveImageToList()
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: createSaveImageAlertMessage().0, message: createSaveImageAlertMessage().1, actions: [saveAction2, saveAction, cancel])
    }
}
