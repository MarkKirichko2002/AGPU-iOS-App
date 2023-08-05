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
        let status = UserDefaults.loadData(type: UserStatusModel.self, key: "user status")
        if status?.id == UserStatusList.list[index].id && status?.isSelected == true {
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
        UIApplication.shared.setAlternateIconName(faculty.appIcon)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("faculty"), object: faculty)
        }
        UserDefaults.SaveData(object: faculty, key: "faculty") {
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                self.isChanged.toggle()
            }
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
            } else {
                print("NOOOOOOO")
            }
        }
        return false
    }
}
