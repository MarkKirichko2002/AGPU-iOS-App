//
//  TimetableSettingsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import UIKit

// MARK: - TimetableSettingsListViewModelProtocol
extension TimetableSettingsListViewModel: TimetableSettingsListViewModelProtocol {
    
    func getAllData() {
        options[0].icon = currentOwnerIcon()
        options[0].name = getSavedOwner()
        options[0].info = getSavedGroup()
        options[1].info = "\(getSavedSubGroup())"
        options[2].info = getSavedPairType().title
        dataChangedHandler?()
    }
    
    func getSavedFaculty()-> AGPUFacultyModel? {
        let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
        return faculty
    }
    
    func getSavedOwner()-> String {
        let owner = UserDefaults.standard.object(forKey: "recentOwner") as? String ?? "GROUP"
        if owner == "GROUP" {
            return "Группа"
        } else if owner == "TEACHER" {
            return "Преподаватель"
        } else if owner == "CLASSROOM" {
            return "Аудитория"
        }
        return "-"
    }
    
    func currentOwnerIcon()-> String {
        let owner = UserDefaults.standard.object(forKey: "recentOwner") as? String ?? "GROUP"
        if owner == "GROUP" {
            return "group"
        } else if owner == "TEACHER" {
            return "profile icon"
        } else if owner == "CLASSROOM" {
            return "door"
        }
        return ""
    }
    
    func currentOwnerScreen()-> UIViewController {
        let owner = UserDefaults.standard.object(forKey: "recentOwner") as? String ?? "GROUP"
        let searchVC = TimeTableSearchListTableViewController()
        searchVC.isSettings = true
        if owner == "GROUP" {
            if let faculty = getSavedFaculty() {
                let vc = FacultyGroupsListTableViewController(faculty: faculty)
                return vc
            }
        } else if owner == "TEACHER" {
            return searchVC
        } else if owner == "CLASSROOM" {
            return searchVC
        }
        return searchVC
    }
    
    func getSavedGroup()-> String {
        let value = (UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-2-1")
        return value
    }
    
    func getSavedSubGroup()-> Int {
        let subGroup = UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
        return subGroup
    }
    
    func getSavedPairType()-> PairType {
        let type = UserDefaults.loadData(type: PairType.self, key: "type") ?? .all
        return type
    }
    
    func observeOptionSelection() {
        NotificationCenter.default.addObserver(forName: Notification.Name("option was selected"), object: nil, queue: .main) { _ in
            self.getAllData()
            self.dataChangedHandler?()
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
