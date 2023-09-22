//
//  AppThemesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.09.2023.
//

import Foundation

// MARK: - AppThemesListViewModelProtocol
extension AppThemesListViewModel: AppThemesListViewModelProtocol {
    
    func themeItem(index: Int)-> AppThemeModel {
        let theme = AppThemes.themes[index]
        return theme
    }
    
    func selectTheme(index: Int) {
        let theme = AppThemes.themes[index]
        UserDefaults.saveData(object: theme, key: "theme") {
            self.themeSelectedHandler?()
            print("выбрана тема")
        }
        NotificationCenter.default.post(name: Notification.Name("App Theme Changed"), object: theme)
    }
    
    func registerThemeSelectedHandler(block: @escaping()->Void) {
        self.themeSelectedHandler = block
    }
    
    func isThemeSelected(index: Int)-> Bool {
        let theme = AppThemes.themes[index]
        if let savedTheme = UserDefaults.loadData(type: AppThemeModel.self, key: "theme") {
            if savedTheme.name == theme.name {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
