//
//  ASPUButtonActions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import Foundation

enum ASPUButtonActions: String, CaseIterable, Codable {
    
    case speechRecognition = "Голосовые команды"
    case timetableWeeks = "Список недель"
    case campusMap = "Карта кампуса"
    case studyPlan = "Учебный план"
    case profile = "Личный кабинет ЭИОС"
    case manual = "Методические материалы"
    case sections = "Разделы сайта АГПУ"
    case recent = "Недавние моменты"
    case weather = "Погода"
    case things = "Важные вещи"
    case nearestBuilding = "Нужное здание"
    case appThemes = "Темы приложения"
    case appShortcuts = "Шорткаты приложения"
    case favourite = "Избранное"
    
    var icon: String {
        switch self {
        case .speechRecognition:
            return "mic"
        case .timetableWeeks:
            return "clock"
        case .campusMap:
            return "map icon"
        case .studyPlan:
            return "student"
        case .profile:
            return "profile icon"
        case .manual:
            return "book"
        case .sections:
            return "sections icon"
        case .recent:
            return "time.past"
        case .weather:
            return "sun"
        case .things:
            return "exclamation"
        case .nearestBuilding:
            return "map icon"
        case .appThemes:
            return "theme"
        case .appShortcuts:
            return "sections"
        case .favourite:
            return "star"
        }
    }
}
