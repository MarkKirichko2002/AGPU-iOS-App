//
//  SettingsManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import RealmSwift
import Foundation

// MARK: - SettingsManagerProtocol
extension SettingsManager: SettingsManagerProtocol {
    
    // MARK: - Custom Music
    func checkCustomMusicSetting() {
        let id = UserDefaults.standard.object(forKey: "id") as? Int ?? 0
        realmManager.fetchMusicList { music in
            if !music.isEmpty {
                if music[id].isChecked == true {
                    AudioPlayer.shared.PlaySound(resource: music[id].fileName)
                }
            }
        }
    }
    
    // MARK: - Elected Faculty
    func checkCurrentIcon()-> String? {
        let icon = UserDefaults.standard.object(forKey: "icon") as? String ?? "АГПУ"
        return icon
    }
    
    // проверить все настройки
    func checkAllSettings() {
        checkCustomMusicSetting()
    }
}
