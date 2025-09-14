//
//  SpeechRecognitionSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2025.
//

import UIKit

final class SpeechRecognitionSplashScreenViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    let splashScreenStorageManager = SplashScreenStorageManager()
    let speechRecognitionManager = SpeechRecognitionManager()
    var currentScreen = SplashScreenOptions.regular
    
    var splashScreenViewControllerHandler: ((UIViewController)->Void)?
    var alertHandler: ((Bool, String, String)->Void)?
    var skipHandler: ((UIViewController)->Void)?
    
}
