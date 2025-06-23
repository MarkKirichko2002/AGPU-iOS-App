//
//  NewsOptionsFilters.swift
//  AGPU
//
//  Created by Марк Киричко on 05.04.2024.
//

import Foundation

enum NewsOptionsFilters: String, CaseIterable, Codable {
    case today = "Сегодня"
    case yesterday = "Вчера"
    case dayBeforeYesterday = "Позавчера"
    case currentWeek = "Текущая неделя"
    case all = "Все новости"
    
    var voiceCommand: String {
        switch self {
        case .today:
            return "сегодн"
        case .yesterday:
            return "вчера"
        case .dayBeforeYesterday:
            return "позавчера"
        case .currentWeek:
            return "недел"
        case .all:
            return "все новости"
        }
    }
}
