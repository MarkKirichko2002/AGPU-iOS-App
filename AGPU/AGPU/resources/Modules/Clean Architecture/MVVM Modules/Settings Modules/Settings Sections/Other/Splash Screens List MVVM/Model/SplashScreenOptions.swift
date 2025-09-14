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
    case speechRecognition = "Распознование речи"
    case random = "Рандом"
    case none = "Без заставки"
    
    var voiceCommand: String {
        switch self {
        case .regular:
            return "обычн"
        case .faculty:
            return "факульт"
        case .newyear:
            return "новый год"
        case .weather:
            return "погод"
        case .news:
            return "новост"
        case .timetable:
            return "расписани"
        case .corps:
            return "корпус"
        case .technopark:
            return "технопарк"
        case .quantorium:
            return "кванториум"
        case .season:
            return "время года"
        case .halloween:
            return "хэллоуин"
        case .additionalTab:
            return "вкладка"
        case .custom:
            return "свой"
        case .speechRecognition:
            return "голос"
        case .random:
            return "рандом"
        case .none:
            return ""
        }
    }
    
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
        case .speechRecognition:
            return ""
        case .random:
            return "random"
        case .none:
            return ""
        }
    }
}
