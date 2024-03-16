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
}
