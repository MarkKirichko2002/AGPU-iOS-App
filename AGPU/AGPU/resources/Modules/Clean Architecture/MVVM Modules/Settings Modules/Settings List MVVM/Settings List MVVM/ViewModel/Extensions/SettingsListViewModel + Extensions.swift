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
    
    func getAppThemeInfo()-> AppThemeModel {
        if let status = UserDefaults.loadData(type: AppThemeModel.self, key: "theme") {
            return status
        } else {
            return AppThemes.themes[0]
        }
    }
    
    func observeOptionSelection() {
        NotificationCenter.default.addObserver(forName: Notification.Name("option was selected"), object: nil, queue: .main) { _ in
            self.isChanged.toggle()
        }
    }
}
