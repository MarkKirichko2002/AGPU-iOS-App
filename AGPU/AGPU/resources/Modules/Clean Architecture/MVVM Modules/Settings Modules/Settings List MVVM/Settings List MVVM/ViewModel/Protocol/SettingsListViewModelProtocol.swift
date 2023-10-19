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
    func getAppThemeInfo()-> AppThemeModel
    func observeOptionSelection()
}
