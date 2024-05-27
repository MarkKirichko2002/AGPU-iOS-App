//
//  SettingsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

// MARK: - SettingsListViewModelProtocol
extension SettingsListViewModel: SettingsListViewModelProtocol {
    
    func sectionsCount()-> Int {
        return 3
    }
    
    func getStatusInfo()-> UserStatusModel {
        if let status = UserDefaults.loadData(type: UserStatusModel.self, key: "user status") {
            return status
        } else {
            return UserStatusList.list[0]
        }
    }
    
    func getSelectedFacultyInfo()-> AGPUFacultyModel? {
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            return faculty
        }
        return nil
    }
    
    func getSavedNewsCategoryInfo()-> String {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? "-"
        if savedNewsCategory != "-" {
            let category = NewsCategories.categories.first { $0.newsAbbreviation == savedNewsCategory}
            return category?.name ?? ""
        } else {
            return "АГПУ"
        }
    }
    
    func getScreenPresentationStyleInfo()-> String {
        if let savedStyle = UserDefaults.loadData(type: ScreenPresentationStyles.self, key: "screen presentation style") {
            return savedStyle.rawValue
        }
        return "Не показывать"
    }
    
    func getOnlyMainVariantInfo()-> String {
        if let variant = UserDefaults.loadData(type: OnlyMainVariants.self, key: "variant") {
            return "Вариант (\(variant.rawValue))"
        }
        return "Вариант (По умолчанию)"
    }
    
    func getSplashScreenInfo()-> String {
        if let option = UserDefaults.loadData(type: SplashScreenOptions.self, key: "splash option") {
            return option.rawValue
        }
        return "Обычный"
    }
    
    func getAppIconInfo()-> String {
        
        var iconName = ""
        
        if let currentIconName = UIApplication.shared.alternateIconName {
            
            if let icon = AppIcons.icons.first(where: {  $0.appIcon == currentIconName }) {
                iconName = icon.name
            } else {
                if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
                    if let icon = AGPUFaculties.faculties.first(where: { $0.AppIcon == faculty.AppIcon }) {
                        iconName = icon.abbreviation
                    }
                }
            }
        } else {
            return "АГПУ"
        }
        return iconName
    }
    
    func getAppThemeInfo()-> AppThemeModel {
        if let status = UserDefaults.loadData(type: AppThemeModel.self, key: "theme") {
            return status
        } else {
            return AppThemes.themes[0]
        }
    }
    
    func getAppVersion()-> String {
        var appVersion = ""
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = currentVersion
        }
        return appVersion
    }
    
    func observeOptionSelection() {
        NotificationCenter.default.addObserver(forName: Notification.Name("option was selected"), object: nil, queue: .main) { _ in
            self.isChanged.toggle()
        }
    }
}
