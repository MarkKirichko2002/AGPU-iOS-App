//
//  ScreenPresentationStylesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 27.05.2024.
//

import Foundation

class ScreenPresentationStylesListViewModel {
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
