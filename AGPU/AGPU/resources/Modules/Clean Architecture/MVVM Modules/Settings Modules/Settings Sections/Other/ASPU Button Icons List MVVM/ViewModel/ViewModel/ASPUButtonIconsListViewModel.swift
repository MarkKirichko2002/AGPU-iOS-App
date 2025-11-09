//
//  ASPUButtonIconsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import Foundation

final class ASPUButtonIconsListViewModel {
    
    var faculty: AGPUFacultyModel?
    
    var icons = ASPUButtonIcons.icons
    
    var dataChangedHandler: (()->Void)?
    var iconSelectedHandler: (()->Void)?
    var alertHandler: ((String, String)->Void)?
    var photoHandler: (()->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
