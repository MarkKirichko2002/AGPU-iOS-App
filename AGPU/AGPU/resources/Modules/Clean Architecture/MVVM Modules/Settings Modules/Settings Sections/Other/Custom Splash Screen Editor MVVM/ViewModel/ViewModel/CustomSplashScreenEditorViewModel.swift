//
//  CustomSplashScreenEditorViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.02.2024.
//

import Foundation

class CustomSplashScreenEditorViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var colorOption = BackgroundColors.system
    var screenUpdatedHandler: ((CustomSplashScreenModel)->Void)?
}