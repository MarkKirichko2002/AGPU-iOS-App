//
//  TabOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2024.
//

import Foundation

struct TabOptionModel: Codable {
    let title: String
}

struct TabOptionsSectionModel {
    let title: String
    let options: [TabOptionModel]
}

struct TabOptionsSections {
    static let sections = [
        TabOptionsSectionModel(title: "news", options: [
            TabOptionModel(title: "Новости за сегодня"),
            TabOptionModel(title: "Список категорий"),
            TabOptionModel(title: "Список страниц"),
            TabOptionModel(title: "Рандомайзер"),
            TabOptionModel(title: "Фильтрация")
        ]),
        TabOptionsSectionModel(title: "favourites", options: [
            TabOptionModel(title: "Добавить раздел"),
            TabOptionModel(title: "Изменить порядок"),
        ]),
        TabOptionsSectionModel(title: "timetable", options: [
            TabOptionModel(title: "Календарь"),
            TabOptionModel(title: "Список недель"),
            TabOptionModel(title: "Список дней"),
            TabOptionModel(title: "Избранное"),
            TabOptionModel(title: "Поиск")
        ]),
        TabOptionsSectionModel(title: "settings", options: [
            TabOptionModel(title: "Новости"),
            TabOptionModel(title: "Расписание"),
            TabOptionModel(title: "Панель вкладок"),
            TabOptionModel(title: "Темы приложения"),
            TabOptionModel(title: "АГПУ кнопка"),
            TabOptionModel(title: "Шорткаты приложения"),
        ]),
    ]
}
