//
//  AdditionalTabVariants.swift
//  AGPU
//
//  Created by Марк Киричко on 25.12.2024.
//

import Foundation

enum AdditionalTabVariants: String, CaseIterable, Codable {
    case button = "АГПУ кнопка"
    case weeksList = "Список недель"
    case webSections = "Разделы сайта"
    case maps = "Карты"
    case weather = "Погода"
    case building = "Нужное здание"
    case none = "Ничего"
    
    var icon: String {
        switch self {
        case .button:
            return "button"
        case .weeksList:
            return "calendar"
        case .webSections:
            return "online"
        case .maps:
            return "map icon"
        case .weather:
            return "sun"
        case .building:
            return "pin"
        case .none:
            return ""
        }
    }
}
