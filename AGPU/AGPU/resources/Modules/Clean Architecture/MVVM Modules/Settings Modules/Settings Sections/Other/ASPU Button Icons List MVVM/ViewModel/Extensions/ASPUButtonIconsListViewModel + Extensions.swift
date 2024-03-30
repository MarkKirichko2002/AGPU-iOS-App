//
//  ASPUButtonIconsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import Foundation

// MARK: - IASPUButtonIconsListViewModel
extension ASPUButtonIconsListViewModel: IASPUButtonIconsListViewModel {
    
    func numberOfASPUButtonIcons()-> Int {
        return ASPUButtonIcons.icons.count
    }
    
    func ASPUButtonIconItem(index: Int)-> ASPUButtonIconModel {
        let icon = ASPUButtonIcons.icons[index]
        return icon
    }
    
    func getSelectedFacultyData() {
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            ASPUButtonIcons.icons[4].name = "\(faculty.abbreviation)"
            ASPUButtonIcons.icons[4].icon = faculty.icon
            self.faculty = faculty
            self.dataChangedHandler?()
        } else {
            ASPUButtonIcons.icons[4].name = "нет факультета"
            ASPUButtonIcons.icons[4].icon = ""
            self.faculty = nil
            self.dataChangedHandler?()
        }
    }
    
    func selectASPUButtonIcon(index: Int) {
        
        let icon = ASPUButtonIconItem(index: index)
        let savedIcon = settingsManager.checkCurrentIcon()
        
        if savedIcon != icon.icon {
            if icon.id == 5 {
                if let faculty = faculty {
                    self.iconSelectedHandler?()
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("icon"), object: faculty.icon)
                    UserDefaults.standard.setValue(icon.icon, forKey: "icon")
                    UserDefaults.standard.setValue(icon.name, forKey: "icon name")
                    HapticsManager.shared.hapticFeedback()
                } else {
                    alertHandler?("Нет факультета", "Выберите свой факультет")
                }
            } else {
                self.iconSelectedHandler?()
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("icon"), object: icon.icon)
                UserDefaults.standard.setValue(icon.icon, forKey: "icon")
                UserDefaults.standard.setValue(icon.name, forKey: "icon name")
                HapticsManager.shared.hapticFeedback()
            }
        }
    }
    
    func isASPUButtonIconSelected(index: Int)-> Bool {
        
        let icon = ASPUButtonIconItem(index: index)
        let savedIcon = settingsManager.checkCurrentIcon()
        
        if savedIcon == icon.icon {
            return true
        } else {
            return false
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerIconSelectedHandler(block: @escaping()->Void) {
        self.iconSelectedHandler = block
    }
    
    func registerAlertHandler(block: @escaping(String, String)->Void) {
        self.alertHandler = block
    }
}
