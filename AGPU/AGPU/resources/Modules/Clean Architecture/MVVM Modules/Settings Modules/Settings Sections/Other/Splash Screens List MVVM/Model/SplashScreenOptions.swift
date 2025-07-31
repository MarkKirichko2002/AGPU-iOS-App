//
//  SplashScreenOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.01.2024.
//

import Foundation

enum SplashScreenOptions: String, CaseIterable, Codable {
    case regular = "Обычный"
    case faculty = "Факультет"
    case newyear = "Новый год"
    case weather = "Погода"
    case news = "Новости"
    case timetable = "Расписание"
    case corps = "Корпуса"
    case technopark = "Технопарк"
    case quantorium = "Кванториум"
    case season = "Сезон"
    case halloween = "Хэллоуин"
    case additionalTab = "Дополнительная вкладка"
    case custom = "Кастомный"
    case random = "Рандом"
    case none = "Без заставки"
    
    var video: String {
        switch self {
        case .regular:
            return "regular"
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
        case .corps:
            return ""
        case .technopark:
            return "technopark"
        case .quantorium:
            return "quantorium"
        case .season:
            return "season"
        case .halloween:
            return "pumpkin"
        case .additionalTab:
            return "additional tab"
        case .custom:
            return "custom"
        case .random:
            return "random"
        case .none:
            return ""
        }
    }
}
