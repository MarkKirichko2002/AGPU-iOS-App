//
//  TimetablePseudonymCategories.swift
//  AGPU
//
//  Created by Марк Киричко on 22.10.2025.
//

import Foundation

enum TimetablePseudonymCategories: String, CaseIterable {
    case time = "Время"
    case discipline = "Дисциплины"
    case teacher = "Преподаватели"
    case audience = "Аудитории"
    case group = "Группы"
    
    var icon: String {
        switch self {
        case .time:
            return "clock"
        case .discipline:
            return "book"
        case .teacher:
            return "profile icon"
        case .audience:
            return "door"
        case .group:
            return "group icon"
        }
    }
}
