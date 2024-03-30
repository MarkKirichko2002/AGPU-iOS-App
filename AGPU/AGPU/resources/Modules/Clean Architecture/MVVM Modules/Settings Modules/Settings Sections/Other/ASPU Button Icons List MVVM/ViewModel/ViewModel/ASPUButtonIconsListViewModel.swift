//
//  ASPUButtonIconsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import Foundation

class ASPUButtonIconsListViewModel {
    
    var faculty: AGPUFacultyModel?
    
    var dataChangedHandler: (()->Void)?
    var iconSelectedHandler: (()->Void)?
    var alertHandler: ((String, String)->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
