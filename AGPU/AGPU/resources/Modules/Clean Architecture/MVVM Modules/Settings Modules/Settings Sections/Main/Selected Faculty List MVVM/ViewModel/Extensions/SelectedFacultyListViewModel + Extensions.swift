//
//  SelectedFacultyListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import UIKit

// MARK: - SelectedFacultyListViewModelProtocol
extension SelectedFacultyListViewModel: SelectedFacultyListViewModelProtocol {
    
    func facultiesListCount()-> Int {
        return AGPUFaculties.faculties.count
    }
    
    func facultyItem(index: Int)-> AGPUFacultyModel {
        return AGPUFaculties.faculties[index]
    }
    
    func chooseFaculty(index: Int) {
        
        var faculty = AGPUFaculties.faculties[index]
        faculty.isSelected = true
        
        if !isFacultySelected(index: index) {
            
            UserDefaults.saveData(object: faculty, key: "faculty") {
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.isChanged.toggle()
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                }
            }
            
            if let currentIconName = UIApplication.shared.alternateIconName {
                if currentIconName != "AppIcon 8" {
                    UIApplication.shared.setAlternateIconName("AppIcon 8")
                }
            } else {}
            
            UserDefaults.standard.setValue(nil, forKey: "icon")
            UserDefaults.standard.setValue(nil, forKey: "icon name")
            UserDefaults.standard.setValue(nil, forKey: "cathedra")
            UserDefaults.standard.setValue(nil, forKey: "group")
            UserDefaults.standard.setValue(nil, forKey: "subgroup")
            
            NotificationCenter.default.post(name: Notification.Name("category"), object: faculty.newsAbbreviation)
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("icon"), object: nil)
            }
            
            NotificationCenter.default.post(name: Notification.Name("group changed"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("subgroup changed"), object: 0)
        }
    }
    
    func chooseFacultyIcon(index: Int) {
        
        let faculty = AGPUFaculties.faculties[index]
        
        if !isFacultyIconSelected(index: index) {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("icon"), object: faculty.icon)
            }
            UserDefaults.standard.setValue(faculty.icon, forKey: "icon")
            UserDefaults.standard.setValue(faculty.abbreviation, forKey: "icon name")
        }
    }
    
    func cancelFacultyIcon(index: Int) {
        
        if isFacultyIconSelected(index: index) {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("icon"), object: nil)
            }
            UserDefaults.standard.setValue(nil, forKey: "icon")
            UserDefaults.standard.setValue(nil, forKey: "icon name")
        }
    }
    
    func cancelFaculty(index: Int) {
        
        if isFacultySelected(index: index) {
            if let data = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
                if data.id == AGPUFaculties.faculties[index].id && data.isSelected {
                    var faculty: AGPUFacultyModel?
                    faculty = AGPUFaculties.faculties[index]
                    faculty = nil
                    UserDefaults.saveData(object: faculty, key: "faculty") {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            self.isChanged.toggle()
                            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                        }
                    }
                    
                    if let currentIconName = UIApplication.shared.alternateIconName {
                        if currentIconName != "AppIcon 8" {
                            UIApplication.shared.setAlternateIconName("AppIcon 8")
                        }
                    } else {}
                    
                    UserDefaults.standard.setValue(nil, forKey: "icon")
                    UserDefaults.standard.setValue(nil, forKey: "icon name")
                    UserDefaults.standard.setValue(nil, forKey: "group")
                    UserDefaults.standard.setValue(nil, forKey: "subgroup")
                    UserDefaults.standard.setValue(nil, forKey: "cathedra")
                    
                    NotificationCenter.default.post(name: Notification.Name("category"), object: "")
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        NotificationCenter.default.post(name: Notification.Name("icon"), object: nil)
                    }
                    NotificationCenter.default.post(name: Notification.Name("group changed"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("subgroup changed"), object: 0)
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
