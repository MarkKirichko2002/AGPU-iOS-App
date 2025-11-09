//
//  ASPUButtonIconsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import Foundation
import UIKit

// MARK: - IASPUButtonIconsListViewModel
extension ASPUButtonIconsListViewModel: IASPUButtonIconsListViewModel {
    
    func numberOfASPUButtonIcons()-> Int {
        return icons.count
    }
    
    func ASPUButtonIconItem(index: Int)-> ASPUButtonIconModel {
        let icon = icons[index]
        return icon
    }
    
    func getIconsData() {
        getSelectedFacultyData()
        getCustomIconData()
        dataChangedHandler?()
    }
    
    func getSelectedFacultyData() {
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            icons[4].name = "\(faculty.abbreviation)"
            icons[4].icon = UIImage(named: faculty.icon)!.pngData()!
            self.faculty = faculty
        } else {
            icons[4].name = "Нет факультета"
            icons[4].icon = Data()
            self.faculty = nil
        }
    }
    
    func getCustomIconData() {
        icons[5].icon = settingsManager.checkCustomButtonImage().icon
    }
    
    func selectASPUButtonIcon(index: Int) {
        
        let icon = ASPUButtonIconItem(index: index)
        
        if icon.id == 5 {
            if let faculty = faculty {
                self.iconSelectedHandler?()
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                UserDefaults.saveData(object: icon, key: "aspu button icon") {
                    HapticsManager.shared.hapticFeedback()
                }
            } else {
                alertHandler?("Нет факультета", "Выберите свой факультет")
            }
        } else if icon.id == 6 {
            self.iconSelectedHandler?()
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
            UserDefaults.saveData(object: icon, key: "aspu button icon") {
                HapticsManager.shared.hapticFeedback()
            }
            photoHandler?()
        } else {
            self.iconSelectedHandler?()
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
            UserDefaults.saveData(object: icon, key: "aspu button icon") {
                HapticsManager.shared.hapticFeedback()
            }
        }
    }
    
    func updateCustomIconImage(image: UIImage) {
        icons[5].icon = image.pngData()!
        UserDefaults.saveData(object: icons[5], key: "aspu custom button image") {
            UserDefaults.saveData(object: self.icons[5], key: "aspu button icon") {
                self.getIconsData()
            }
        }
    }
    
    func isASPUButtonIconSelected(index: Int)-> Bool {
        
        let icon = ASPUButtonIconItem(index: index)
        let savedIcon = settingsManager.checkCurrentIcon()
        
        return savedIcon.id == icon.id
    }
    
    func titleForNavigation()-> String {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return "Выберите иконку"
        case .informal:
            return "Выбери иконку"
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
    
    func registerPhotoHandler(block: @escaping()->Void) {
        self.photoHandler = block
    }
}
