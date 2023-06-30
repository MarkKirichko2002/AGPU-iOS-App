//
//  SettingsManager.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import RealmSwift
import Foundation

class SettingsManager: SettingsManagerProtocol {
    
    private let realmManager = RealmManager()
    
    // MARK: - Custom Music
    func checkCustomMusicSetting() {
        if let id = UserDefaults.loadData(type: ObjectId.self, key: "id") {
            if let music = realmManager.findMusicItem(by: id) {
                if music.isChecked == true {
                    AudioPlayer.shared.PlaySound(resource: music.fileName)
                }
            }
        }
    }
    
    
    //MARK: - Elected Faculty
    func checkCurrentIcon()-> String? {
        let icon = UserDefaults.loadData(type: AlternateIconModel.self, key: "icon")
        return icon?.icon ?? "АГПУ"
    }
    
    // проверить все настройки
    func checkAllSettings() {
        checkCustomMusicSetting()
    }
}
