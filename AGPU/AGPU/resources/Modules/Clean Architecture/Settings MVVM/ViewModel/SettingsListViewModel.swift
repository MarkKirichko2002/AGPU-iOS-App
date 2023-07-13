//
//  SettingsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import UIKit

class SettingsListViewModel: NSObject {
    
    @objc dynamic var isChanged = false
    
    var observation: NSKeyValueObservation?
    
    // MARK: - факультеты
    
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
        UserDefaults.standard.setValue(faculty.icon, forKey: "icon")
        UserDefaults.SaveData(object: faculty, key: "faculty") {
            self.isChanged.toggle()
        }
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
                UserDefaults.standard.setValue(nil, forKey: "faculty")
                UserDefaults.SaveData(object: faculty, key: "faculty") {
                    self.isChanged.toggle()
                }
            }
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
    
    
    // MARK: - группы
    func groupsListCount()-> Int {
        return AGPUGroups.groups.count
    }
    
    func groupItem(index: Int)-> String {
        return AGPUGroups.groups[index]
    }
    
    func ChangeGroup(index: Int) {
        let group = AGPUGroups.groups[index]
        UserDefaults.standard.setValue(group, forKey: "group")
        self.isChanged.toggle()
    }
    
    func isGroupSelected(index: Int)-> UITableViewCell.AccessoryType {
        let group = UserDefaults.standard.object(forKey: "group") as? String ?? ""
        if group == AGPUGroups.groups[index] {
            return .checkmark
        } else {
            return .none
        }
    }
}
