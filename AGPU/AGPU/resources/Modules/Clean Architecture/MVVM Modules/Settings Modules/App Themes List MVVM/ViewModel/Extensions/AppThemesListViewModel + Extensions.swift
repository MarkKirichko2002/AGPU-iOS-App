//
//  AppThemesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.09.2023.
//

import UIKit

// MARK: - AppThemesListViewModelProtocol
extension AppThemesListViewModel: AppThemesListViewModelProtocol {
    
    func themeItem(index: Int)-> AppThemeModel {
        let theme = AppThemes.themes[index]
        return theme
    }
    
    func selectTheme(index: Int) {
        let themeModel = AppThemes.themes[index]
        let savedTheme = UserDefaults.loadData(type: AppThemeModel.self, key: "theme") ?? AppThemes.themes[0]
        if themeModel.theme != savedTheme.theme {
            UserDefaults.saveData(object: themeModel, key: "theme") {
                self.themeSelectedHandler?(themeModel.theme)
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                print("выбрана тема")
            }
        } else {
            print("тема уже выбрана")
        }
    }
    
    func registerThemeSelectedHandler(block: @escaping(UIUserInterfaceStyle)->Void) {
        self.themeSelectedHandler = block
    }
    
    func isThemeSelected(index: Int)-> Bool {
        let themeModel = AppThemes.themes[index]
        let savedTheme = UserDefaults.loadData(type: AppThemeModel.self, key: "theme") ?? AppThemes.themes[0]
        if savedTheme.name == themeModel.name {
            return true
        } else {
            return false
        }
    }
}
