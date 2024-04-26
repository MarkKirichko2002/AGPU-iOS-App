//
//  TimetableOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import Foundation

struct TimetableOptions {
    
    static let options = [
        TimetableSettingsOptionModel(id: 1, icon: "group icon", name: "", info: ""),
        TimetableSettingsOptionModel(id: 2, icon: "group icon", name: "Подгруппа", info: ""),
        TimetableSettingsOptionModel(id: 3, icon: "clock", name: "Тип пары", info: ""),
        TimetableSettingsOptionModel(id: 4, icon: "sound", name: "Звуки", info: ""),
        TimetableSettingsOptionModel(id: 5, icon: "star", name: "Избранное", info: "")
    ]
}
