//
//  TabOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2024.
//

import Foundation

struct TabOptionModel: Codable, Equatable {
    let id: Int
    var title: String
}

struct TabOptionsSectionModel {
    let title: String
    let options: [TabOptionModel]
}

struct TabOptionsSections {
    static let sections = [
        TabOptionsSectionModel(title: "news", options: [
            TabOptionModel(id: 1, title: "Новости за сегодня"),
            TabOptionModel(id: 2, title: "Список категорий"),
            TabOptionModel(id: 3, title: "Список страниц"),
            TabOptionModel(id: 4, title: "Рандомайзер"),
            TabOptionModel(id: 5, title: "Фильтрация")
        ]),
        TabOptionsSectionModel(title: "sections", options: [
            TabOptionModel(id: 1, title: "Добавить раздел"),
            TabOptionModel(id: 2, title: "Изменить порядок"),
        ]),
        TabOptionsSectionModel(title: "timetable", options: [
            TabOptionModel(id: 1, title: "Календарь"),
            TabOptionModel(id: 2, title: "Список недель"),
            TabOptionModel(id: 3, title: "Список дней"),
            TabOptionModel(id: 4, title: "Избранное"),
            TabOptionModel(id: 5, title: "Поиск")
        ]),
        TabOptionsSectionModel(title: "settings", options: [
            TabOptionModel(id: 1, title: "Новости"),
            TabOptionModel(id: 2, title: "Расписание"),
            TabOptionModel(id: 3, title: "Панель вкладок"),
            TabOptionModel(id: 4, title: "Темы приложения"),
            TabOptionModel(id: 5, title: "АГПУ кнопка"),
            TabOptionModel(id: 6, title: "Шорткаты приложения"),
        ]),
    ]
}
