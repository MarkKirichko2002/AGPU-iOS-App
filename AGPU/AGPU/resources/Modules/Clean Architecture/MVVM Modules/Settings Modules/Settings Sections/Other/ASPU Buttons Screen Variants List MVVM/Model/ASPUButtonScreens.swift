//
//  ASPUButtonScreens.swift
//  AGPU
//
//  Created by Марк Киричко on 10.06.2025.
//

import Foundation

enum ASPUButtonScreens: String, Codable, CaseIterable {
    case timetableDay = "Расписание на день"
    case timetableWeek = "Расписание на неделю"
    case newsList = "Список новостей"
    case newsWebPage = "Web-страница новости"
    case favouriteSections = "Избранные разделы"
    
    var title: String {
        if self == .timetableDay {
            return "timetable day"
        } else if self == .timetableWeek {
            return "timetable week"
        } else if self == .newsList {
            return "news list"
        } else if self == .newsWebPage {
            return "news web page"
        } else if self == .favouriteSections {
            return "favourites sections"
        } else {
            return ""
        }
    }
    
    var notificationName: String {
        if self == .timetableDay {
            return "timetable day"
        } else if self == .newsList {
            return "news list"
        } else if self == .favouriteSections {
            return "favourites sections"
        } else {
            return ""
        }
    }
}
