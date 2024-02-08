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
    case random = "Рандом"
    case none = "Без заставки"
}
