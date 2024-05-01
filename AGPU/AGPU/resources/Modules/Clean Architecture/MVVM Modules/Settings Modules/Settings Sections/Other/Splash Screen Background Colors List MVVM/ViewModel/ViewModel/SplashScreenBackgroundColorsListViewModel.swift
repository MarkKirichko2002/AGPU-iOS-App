//
//  SplashScreenBackgroundColorsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 20.04.2024.
//

import Foundation

class SplashScreenBackgroundColorsListViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var colorSelectedHandler: ((BackgroundColors)->Void)?
    var colorOption: BackgroundColors
    
    init(colorOption: BackgroundColors) {
        self.colorOption = colorOption
    }
}
