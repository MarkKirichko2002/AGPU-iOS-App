//
//  SettingsManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import Foundation

protocol SettingsManagerProtocol {
    func checkCustomMusicSetting()
    func checkCurrentIcon()-> String
    func checkAllSettings()
}
