//
//  SettingsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

// MARK: - SettingsListViewModelProtocol
extension SettingsListViewModel: SettingsListViewModelProtocol {
    
    func sectionsCount()->Int {
        return 2
    }
    
    func facultiesListCount()-> Int {
        return AGPUFaculties.faculties.count
    }
    
    func facultyItem(index: Int)-> AGPUFacultyModel {
        return AGPUFaculties.faculties[index]
    }
    
    func ChooseFaculty(index: Int) {
        var faculty = AGPUFaculties.faculties[index]
        faculty.isSelected = true
        UIApplication.shared.setAlternateIconName(faculty.appIcon)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("faculty"), object: faculty)
        }
        UserDefaults.SaveData(object: faculty, key: "faculty") {
            self.isChanged.toggle()
        }
        UserDefaults.standard.setValue(faculty.icon, forKey: "icon")
        UserDefaults.standard.setValue(nil, forKey: "group")
        UserDefaults.standard.setValue(nil, forKey: "cathedra")
    }
    
    func CancelFaculty(index: Int) {
        if let data = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            if data.id == AGPUFaculties.faculties[index].id && data.isSelected {
                var faculty: AGPUFacultyModel?
                faculty = AGPUFaculties.faculties[index]
                faculty = nil
                UIApplication.shared.setAlternateIconName("AppIcon 7")
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    NotificationCenter.default.post(name: Notification.Name("faculty"), object: faculty)
                }
                UserDefaults.SaveData(object: faculty, key: "faculty") {
                    self.isChanged.toggle()
                }
                UserDefaults.standard.setValue(nil, forKey: "icon")
                UserDefaults.standard.setValue(nil, forKey: "group")
                UserDefaults.standard.setValue(nil, forKey: "cathedra")
            }
        }
    }
    
    func isFacultySelected(index: Int)-> Bool {
        let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
        if faculty?.id == AGPUFaculties.faculties[index].id && faculty?.isSelected == true {
            return true
        } else {
            return false
        }
    }
    
    func isFacultySelected(index: Int)-> UITableViewCell.AccessoryType {
        let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
        if faculty?.id == AGPUFaculties.faculties[index].id && faculty?.isSelected == true {
            return .checkmark
        } else {
            return .none
        }
    }
    
    func isFacultySelectedColor(index: Int)-> UIColor {
        let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
        if faculty?.id == AGPUFaculties.faculties[index].id && faculty?.isSelected == true {
            return UIColor.systemGreen
        } else {
            return UIColor.black
        }
    }
}
