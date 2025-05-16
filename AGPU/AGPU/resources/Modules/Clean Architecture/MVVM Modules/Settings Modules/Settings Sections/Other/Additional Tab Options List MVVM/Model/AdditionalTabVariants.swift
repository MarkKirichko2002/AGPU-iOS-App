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
}
