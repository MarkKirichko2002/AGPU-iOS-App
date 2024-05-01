//
//  ICustomSplashScreenEditorViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.02.2024.
//

import Foundation

protocol ICustomSplashScreenEditorViewModel {
    func saveCustomSplashScreen(screen: CustomSplashScreenModel)
    func getCustomSplashScreen()
    func registerScreenUpdatedHandler(block: @escaping(CustomSplashScreenModel)->Void)
}
