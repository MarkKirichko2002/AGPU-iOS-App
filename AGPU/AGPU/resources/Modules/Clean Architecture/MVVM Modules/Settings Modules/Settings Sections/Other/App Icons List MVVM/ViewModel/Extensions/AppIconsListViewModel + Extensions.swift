//
//  AppIconsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 10.10.2023.
//

import UIKit

// MARK: - AppIconsListViewModelProtocol
extension AppIconsListViewModel: AppIconsListViewModelProtocol {
    
    func numberOfAppIcons()-> Int {
        return AppIcons.icons.count
    }
    
    func appIconItem(index: Int)-> AppIconModel {
        let icon = AppIcons.icons[index]
        return icon
    }
    
    func getSelectedFacultyData() {
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            AppIcons.icons[5].name = "\(faculty.abbreviation)"
            AppIcons.icons[5].icon = faculty.newsAbbreviation
            AppIcons.icons[5].appIcon = faculty.AppIcon
            AppIcons.icons[5].url = faculty.url
            self.faculty = faculty
            self.dataChangedHandler?()
        } else {
            AppIcons.icons[5].name = "Нет факультета"
            AppIcons.icons[5].icon = ""
            AppIcons.icons[5].appIcon = ""
            self.faculty = nil
            self.dataChangedHandler?()
        }
    }
    
    func selectAppIcon(index: Int) {
        
        let icon = AppIcons.icons[index]
        
        if let currentIconName = UIApplication.shared.alternateIconName {
            
            print("Текущая иконка приложения: \(currentIconName)")
            
            if icon.id == 6 {
                
                if let _ = faculty {
                    if currentIconName != icon.appIcon {
                        UIApplication.shared.setAlternateIconName(icon.appIcon)
                        self.iconSelectedHandler?()
                        NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                        HapticsManager.shared.hapticFeedback()
                    }
                } else {
                    print("нет факультета")
                    alertHandler?("Нет факультета", "Выберите свой факультет")
                }
            } else {
                
                if currentIconName != icon.appIcon {
                    UIApplication.shared.setAlternateIconName(icon.appIcon)
                    self.iconSelectedHandler?()
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                    HapticsManager.shared.hapticFeedback()
                } else {
                    print("Текущая иконка приложения уже соответствует выбранной иконке")
                }
            }
            
        } else {
            
            print("Текущая иконка приложения: Основная иконка")
            
            let a = "AppIcon"
            
            if icon.id == 6 {
                
                if let _ = faculty {
                    UIApplication.shared.setAlternateIconName(icon.appIcon)
                    self.iconSelectedHandler?()
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                    HapticsManager.shared.hapticFeedback()
                } else {
                    print("нет факультета")
                    alertHandler?("Нет факультета", "Выберите свой факультет")
                }
            } else {
                
                if a != icon.appIcon && icon.id != 5 {
                    UIApplication.shared.setAlternateIconName(icon.appIcon)
                    self.iconSelectedHandler?()
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                    HapticsManager.shared.hapticFeedback()
                } else {
                    print("Текущая иконка приложения уже соответствует выбранной иконке")
                }
            }
        }
    }
    
    func isAppIconSelected(index: Int)-> Bool {
        
        let icon = AppIcons.icons[index]
        
        if let currentIconName = UIApplication.shared.alternateIconName {
            
            if currentIconName == icon.appIcon {
                return true
            } else {
                return false
            }
        } else {
            
            if icon.id == 1 {
                return true
            }
        }
        return false
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
