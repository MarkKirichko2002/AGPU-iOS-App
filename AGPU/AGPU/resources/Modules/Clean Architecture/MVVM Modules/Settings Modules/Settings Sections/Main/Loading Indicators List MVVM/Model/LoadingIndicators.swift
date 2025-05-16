//
//  LoadingIndicators.swift
//  AGPU
//
//  Created by Марк Киричко on 10.07.2024.
//

import Foundation

enum LoadingIndicators: String, Codable, CaseIterable {
    case regular = "Обычный"
    case category = "Категория"
    case date = "Дата"
    case label = "Надпись"
    case timeOfDay = "Время суток"
    case season = "Сезон"
}
