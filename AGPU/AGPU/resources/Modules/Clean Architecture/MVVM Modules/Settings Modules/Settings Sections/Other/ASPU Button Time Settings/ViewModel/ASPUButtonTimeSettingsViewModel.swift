//
//  ASPUButtonTimeSettingsViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.06.2025.
//

import Foundation

final class ASPUButtonTimeSettingsViewModel {
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    var screen: ASPUButtonScreens
    
    init(screen: ASPUButtonScreens) {
        self.screen = screen
    }
    
    func getSavedTimeLimit()-> Int {
        return settingsManager.loadASPUButtonTime(title: screen.notificationName)
    }
    
    func getCurrentTimeLimitInfo()-> String {
        let time = settingsManager.loadASPUButtonTime(title: screen.notificationName)
        return configureTime(time: time)
    }
    
    func saveTimeLimit(time: Int) {
        settingsManager.saveASPUButtonTime(title: screen.notificationName, time: time)
    }
    
    func configureTime(time: Int)-> String {
        if time == 0 {
            return "Не прятать кнопку"
        } else {
            return "Прятать кнопку через \(time) с"
        }
    }
}
