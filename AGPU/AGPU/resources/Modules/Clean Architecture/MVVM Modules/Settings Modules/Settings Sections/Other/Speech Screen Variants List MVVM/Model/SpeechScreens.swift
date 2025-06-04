//
//  SpeechScreens.swift
//  AGPU
//
//  Created by Марк Киричко on 30.12.2024.
//

import Foundation

enum SpeechScreens: String, Codable, CaseIterable {
    case timetableDay = "Экран расписание на день"
    case timetableWeek = "Экран расписание на неделю"
    case pairInfo = "Экран информация о паре"
    case newsList = "Экран список новостей"
    case newsWeb = "Экран Web-страница новости"
    case ARNews = "Экран AR-новости"
    case ARTimetable = "Экран AR-расписание"
}
