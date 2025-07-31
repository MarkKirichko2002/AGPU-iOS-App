//
//  AdditionalTabSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2025.
//

import Foundation

final class AdditionalTabSplashScreenViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    var additionalTabHandler: ((String, String)->Void)?
    
}
