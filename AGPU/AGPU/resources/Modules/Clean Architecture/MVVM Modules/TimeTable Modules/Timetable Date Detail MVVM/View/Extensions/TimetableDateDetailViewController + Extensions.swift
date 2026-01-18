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

// MARK: - ScreenMenuOptionsListTableViewControllerDelegate
extension TimetableDateDetailViewController: ScreenMenuOptionsListTableViewControllerDelegate {
    
    func listWasUpdated() {
        updateMenu()
    }
    
    func updateMenu() {
        guard let button = view.subviews.first(where: { $0.accessibilityIdentifier == "button" }) else {return}
        (button as? UIButton)?.menu = setUpTimetableMenu()
    }
}

extension TimetableDateDetailViewController {
    
    func setUpTimetableMenu()-> UIMenu {
        let savedOptions = viewModel.loadSavedMenuOptions()
        let options = savedOptions.map { findOption(option: $0) }
        return UIMenu(title: "Расписание", children: options)
    }
    
    func getAllOptions()-> [UIAction] {
        
        let searchAction = UIAction(title: "Поиск") { _ in
            let vc = TimeTableSearchListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let refresh = UIAction(title: "Обновить") { _ in
            self.optionsList.isEnabled = false
            self.viewModel.refreshTimetable()
        }
        
        let ARAction = UIAction(title: "AR режим") { _ in
            let vc = TimetableARViewController(id: self.id, subgroup: self.subgroup, date: self.date, owner: self.owner)
            vc.image = self.timetableImage.image ?? UIImage()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let nearBuildingAction = UIAction(title: "Нужное здание") { _ in
            let vc = NearBuildingViewController(info: .audiences)
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        let groupsList = UIAction(title: "Группы") { _ in
            let vc = AllGroupsListTableViewController(group: self.viewModel.id)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let subGroupsList = UIAction(title: "Подгруппы") { _ in
            let vc = SubGroupsListTableViewController(subgroup: self.viewModel.subgroup, disciplines: self.viewModel.allDisciplines)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // преподаватели
        let teachersList = UIAction(title: "Преподаватели") { _ in
            let vc = DepartmentsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let audiencesList = UIAction(title: "Аудитории") { _ in
            let vc = CorpsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let favouritesList = UIAction(title: "Избранное") { _ in
            let vc = TimeTableFavouriteItemsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let filterAction = UIAction(title: "Фильтрация") { _ in
            let vc = TimetableFilterCategoriesListTableViewController(date: self.date, type: self.viewModel.type, disciplines: self.viewModel.allDisciplines, building: self.viewModel.currentBuilding, time: self.viewModel.currentTime)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let saveTimetable = UIAction(title: "Сохранить") { _ in
            self.showSaveImageAlert()
        }
        
        let shareAction = UIAction(title: "Поделиться") { _ in
            self.share()
        }
        return [
            searchAction,
            refresh,
            ARAction,
            nearBuildingAction,
            groupsList,
            subGroupsList,
            teachersList,
            audiencesList,
            favouritesList,
            filterAction,
            saveTimetable,
            shareAction
        ]
    }
    
    func findOption(option: MenuOptionModel)-> UIAction  {
        let originalOptions = getAllOptions()
        let searchOption = TimetableDateOptions.list.first(where: { $0.name == option.name })!
        let item = originalOptions.first { $0.title == searchOption.name }!
        return item
    }
}

extension TimetableDateDetailViewController {
    
    func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить в фото", style: .default) { _ in
            guard let image = self.viewModel.image else {return}
            self.imageSaver.writeToPhotoAlbum(image: image)
        }
        
        let saveAction2 = UIAlertAction(title: "Сохранить в изображения", style: .default) { _ in
            self.viewModel.saveImageToList()
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: createSaveImageAlertMessage().0, message: createSaveImageAlertMessage().1, actions: [saveAction2, saveAction, cancel])
    }
}
