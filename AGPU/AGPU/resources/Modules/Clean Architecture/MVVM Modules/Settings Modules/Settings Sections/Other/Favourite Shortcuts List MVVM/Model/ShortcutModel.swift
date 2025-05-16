//
//  ShortcutModel.swift
//  AGPU
//
//  Created by Марк Киричко on 06.12.2024.
//

import Foundation

struct ShortcutModel: Codable {
    let id: String
    var title: String
    var subtitle: String
    let icon: String
}

struct AppShortcuts {
    static let items = [
        ShortcutModel(id: "building", title: "Здание", subtitle: "Найти ближайшее", icon: "marker"),
        ShortcutModel(id: "maps", title: "Карты", subtitle: "Показать корпуса", icon: "map"),
        ShortcutModel(id: "weeks", title: "Список недель", subtitle: "Показать список всех недель", icon: "clock"),
        ShortcutModel(id: "calendar", title: "Календарь", subtitle: "Открыть для расписания", icon: "calendar icon"),
        ShortcutModel(id: "website sections", title: "Разделы сайта АГПУ", subtitle: "Показать список разделов сайта АГПУ", icon: "online"),
        ShortcutModel(id: "today news", title: "Новости за сегодня", subtitle: "Показать список актуальных новостей", icon: "mail"),
        ShortcutModel(id: "voice commands", title: "Голосовые команды", subtitle: "Начать говорить", icon: "microphone")
    ]
}
