//
//  CustomSplashScreenEditorViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 28.02.2024.
//

import UIKit

// MARK: ICustomSplashScreenViewModel
extension CustomSplashScreenEditorViewModel: ICustomSplashScreenEditorViewModel {
    
    func saveCustomSplashScreen(screen: CustomSplashScreenModel) {
        settingsManager.saveCustomSplashScreen(screen: screen)
        getCustomSplashScreen()
    }
    
    func getCustomSplashScreen() {
        let screen = settingsManager.getCustomSplashScreen()
        let color = BackgroundColors.allCases.first { $0.title == screen.color } ?? .system
        colorOption = color
        screenUpdatedHandler?(screen)
    }
    
    func registerScreenUpdatedHandler(block: @escaping(CustomSplashScreenModel)->Void) {
        self.screenUpdatedHandler = block
    }
}
