//
//  CustomSplashScreenEditorViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.02.2024.
//

import Foundation

class CustomSplashScreenEditorViewModel {
    
    var screenUpdatedHandler: ((CustomSplashScreenModel)->Void)?
    
    let settingsManager = SettingsManager()
    
}
