//
//  TabBarSoundOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.10.2024.
//

import Foundation

enum TabBarSoundOptions: String, CaseIterable, Codable {
    case halloween = "Хэллоуин"
    case newyear = "Новый год"
    case none = "Ничего"
    
    var sound: String {
        switch self {
        case .halloween:
            return ["смех ведьмы", "скелет", "зомби", "волк"].randomElement()!
        case .newyear:
            return ["фейерверк", "куранты", "тост", "шампанское"].randomElement()!
        case .none:
            return ""
        }
    }
}
