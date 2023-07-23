//
//  SettingsManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import RealmSwift
import Foundation

// onShakeToRecallOption

// MARK: - SettingsManagerProtocol
extension SettingsManager: SettingsManagerProtocol {
   
    // MARK: - Custom Music
    func checkCustomMusicSetting() {
        realmManager.fetchMusicList { music in
            if !music.isEmpty {
                if let id = UserDefaults.standard.object(forKey: "id") as? Int {
                    if music[id].isChecked == true {
                        AudioPlayer.shared.PlaySound(resource: music[id].fileName)
                    }
                }
            }
        }
    }
    
    // MARK: - Elected Faculty
    func checkCurrentIcon()-> String {
        let icon = UserDefaults.standard.object(forKey: "icon") as? String ?? "АГПУ"
        return icon
    }
    
    // MARK: - Shake To Recall
    func checkShakeToRecallOption()-> Bool {
        if let option = UserDefaults.standard.value(forKey: "onShakeToRecallOption") as? Bool {
            return option
        } else {
            return true
        }
    }
    
    // проверить все настройки
    func checkAllSettings() {
        checkCustomMusicSetting()
    }
}
