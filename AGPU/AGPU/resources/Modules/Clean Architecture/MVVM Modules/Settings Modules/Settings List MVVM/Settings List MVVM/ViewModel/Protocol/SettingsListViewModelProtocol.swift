//
//  SettingsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import Foundation

protocol SettingsListViewModelProtocol {
    func sectionsCount()-> Int
    func getStatusInfo()-> UserStatusModel
    func getSelectedFacultyInfo()-> AGPUFacultyModel?
    func getSavedNewsCategoryInfo()-> String
    func getAppIconInfo()-> String
    func getAppThemeInfo()-> AppThemeModel
    func getAppVersion()-> String
    func observeOptionSelection()
}
