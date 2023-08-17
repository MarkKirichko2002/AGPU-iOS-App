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
        return 4
    }
    
    // MARK: - Your Status
    
    func statusListCount()-> Int {
        return 3
    }
    
    func ChooseStatus(index: Int) {
        var status = UserStatusList.list[index]
        status.isSelected = true
        UserDefaults.SaveData(object: status, key: "user status") {
            self.isChanged.toggle()
        }
        NotificationCenter.default.post(name: Notification.Name("user status"), object: status)
    }
    
    func isStatusSelected(index: Int)-> Bool {
        var defaultstatus = UserStatusList.list[0]
        defaultstatus.isSelected = true
        let status = UserDefaults.loadData(type: UserStatusModel.self, key: "user status") ?? defaultstatus
        if status.id == UserStatusList.list[index].id && status.isSelected == true {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Elected Faculty
    
    func facultiesListCount()-> Int {
        return AGPUFaculties.faculties.count
    }
    
    func facultyItem(index: Int)-> AGPUFacultyModel {
        return AGPUFaculties.faculties[index]
    }
    
    func ChooseFaculty(index: Int) {
        
        var faculty = AGPUFaculties.faculties[index]
        faculty.isSelected = true
        
        if !isFacultySelected(index: index) {
            UserDefaults.SaveData(object: faculty, key: "faculty") {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.isChanged.toggle()
                }
            }
            
            if let currentIconName = UIApplication.shared.alternateIconName {
                if currentIconName == "AppIcon 7" {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        NotificationCenter.default.post(name: Notification.Name("faculty"), object: faculty)
                        NotificationCenter.default.post(name: Notification.Name("icon"), object: nil)
                    }
                } else {
                    UIApplication.shared.setAlternateIconName("AppIcon 7")
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        NotificationCenter.default.post(name: Notification.Name("faculty"), object: faculty)
                        NotificationCenter.default.post(name: Notification.Name("icon"), object: nil)
                    }
                }
            }
            
            UserDefaults.standard.setValue(nil, forKey: "icon")
            UserDefaults.standard.setValue(nil, forKey: "cathedra")
            UserDefaults.standard.setValue(nil, forKey: "group")
            UserDefaults.standard.setValue(nil, forKey: "subgroup")
        }
    }
    
    func ChooseFacultyIcon(index: Int) {
        
        let faculty = AGPUFaculties.faculties[index]
        
        if !isFacultyIconSelected(index: index) {
            UIApplication.shared.setAlternateIconName(faculty.appIcon)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("icon"), object: faculty.icon)
            }
            UserDefaults.standard.setValue(faculty.icon, forKey: "icon")
        }
    }
    
    func CancelFacultyIcon(index: Int) {
        UIApplication.shared.setAlternateIconName("AppIcon 7")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("icon"), object: nil)
        }
        UserDefaults.standard.setValue(nil, forKey: "icon")
    }
    
    func CancelFaculty(index: Int) {
        
        if !isFacultySelected(index: index) {
            if let data = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
                if data.id == AGPUFaculties.faculties[index].id && data.isSelected {
                    var faculty: AGPUFacultyModel?
                    faculty = AGPUFaculties.faculties[index]
                    faculty = nil
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        NotificationCenter.default.post(name: Notification.Name("faculty"), object: faculty)
                    }
                    UserDefaults.SaveData(object: faculty, key: "faculty") {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            self.isChanged.toggle()
                        }
                    }
                    
                    if let currentIconName = UIApplication.shared.alternateIconName {
                        if currentIconName == "AppIcon 7" {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                NotificationCenter.default.post(name: Notification.Name("faculty"), object: nil)
                            }
                        } else {
                            UIApplication.shared.setAlternateIconName("AppIcon 7")
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                NotificationCenter.default.post(name: Notification.Name("faculty"), object: nil)
                            }
                        }
                    }
                    UserDefaults.standard.setValue(nil, forKey: "icon")
                    UserDefaults.standard.setValue(nil, forKey: "group")
                    UserDefaults.standard.setValue(nil, forKey: "subgroup")
                    UserDefaults.standard.setValue(nil, forKey: "cathedra")
                    NotificationCenter.default.post(name: Notification.Name("group changed"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("subgroup changed"), object: nil)
                }
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
    
    func isFacultyIconSelected(index: Int)-> Bool {
        let icon = UserDefaults.standard.string(forKey: "icon")
        if icon == AGPUFaculties.faculties[index].icon {
            return true
        } else {
            return false
        }
    }
    
    func isCathedraSelected(index: Int)-> Bool {
        let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
        let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra")
        if faculty?.id == AGPUFaculties.faculties[index].id && faculty?.isSelected == true {
            if cathedra != nil {
                return true
            } else {
                print("NO")
            }
        }
        return false
    }
    
    func isGroupSelected(index: Int)-> Bool {
        let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
        let group = UserDefaults.standard.string(forKey: "group")
        if faculty?.id == AGPUFaculties.faculties[index].id && faculty?.isSelected == true {
            if group != nil {
                return true
            }
        }
        return false
    }
    
    func isSubGroupSelected(index: Int)-> Bool {
        let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
        let subgroup = UserDefaults.standard.string(forKey: "subgroup")
        if faculty?.id == AGPUFaculties.faculties[index].id && faculty?.isSelected == true {
            if subgroup != nil {
                return true
            }
        }
        return false
    }
}
