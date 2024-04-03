//
//  SplashScreenOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.01.2024.
//

import Foundation

enum SplashScreenOptions: String, CaseIterable, Codable {
    case regular = "Обычный"
    case status = "Статус"
    case faculty = "Факультет"
    case newyear = "Новый год"
    case weather = "Погода"
    case news = "Новости"
    case timetable = "Расписание"
    case custom = "Свой"
    case random = "Рандом"
    case none = "Без заставки"
    
    var video: String {
        switch self {
        case .regular:
            return "regular"
        case .status:
            return "status"
        case .faculty:
            return "faculty"
        case .newyear:
            return "new year"
        case .weather:
            return "weather"
        case .news:
            return "news"
        case .timetable:
            return "timetable"
        case .custom:
            return "custom"
        case .random:
            return ""
        case .none:
            return ""
        }
    }
}
