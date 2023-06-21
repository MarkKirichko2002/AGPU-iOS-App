//
//  SettingsManager.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import Foundation

class SettingsManager: SettingsManagerProtocol {
    
   // MARK: - Relax Mode
   func checkRelaxModeSetting() {
        let music = UserDefaults.loadData()
        if music?.isChecked == true {
            AudioPlayer.shared.PlaySound(resource: music?.fileName ?? "")
        }
    }
    
    // проверить все настройки
    func checkAllSettings() {
        checkRelaxModeSetting()
    }
}
