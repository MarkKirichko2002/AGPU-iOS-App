//
//  TabColorsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 18.04.2024.
//

import Foundation

class TabColorsListViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    
}
