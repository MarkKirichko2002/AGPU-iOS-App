//
//  SplashScreenOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.01.2024.
//

import Foundation

enum SplashScreenOptions: String, CaseIterable, Codable {
    case regular = "обычный"
    case faculty = "факультет"
    case newyear = "новый год"
    case random = "рандом"
    case none = "без заставки"
}
