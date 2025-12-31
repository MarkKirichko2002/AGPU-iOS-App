//
//  MenuOptionModel.swift
//  AGPU
//
//  Created by Марк Киричко on 10.11.2025.
//

import Foundation

struct MenuOptionModel: Equatable, Codable {
    let id: Int
    let name: String
}

struct TimetableDayOptions {
    static var list = [
        MenuOptionModel(id: 1, name: "Поиск"),
        MenuOptionModel(id: 2, name: "Псевдонимы"),
        MenuOptionModel(id: 3, name: "AR режим"),
        MenuOptionModel(id: 4, name: "Нужное здание"),
        MenuOptionModel(id: 5, name: "Группы"),
        MenuOptionModel(id: 6, name: "Подгруппы"),
        MenuOptionModel(id: 7, name: "Преподаватели"),
        MenuOptionModel(id: 8, name: "Аудитории"),
        MenuOptionModel(id: 9, name: "Избранное"),
        MenuOptionModel(id: 10, name: "Список дней"),
        MenuOptionModel(id: 11, name: "Недели"),
        MenuOptionModel(id: 12, name: "Календарь"),
        MenuOptionModel(id: 13, name: "Фильтрация"),
        MenuOptionModel(id: 14, name: "Сохранить"),
        MenuOptionModel(id: 15, name: "Навигация"),
        MenuOptionModel(id: 16, name: "Голосовые команды"),
        MenuOptionModel(id: 17, name: "Поделиться")
    ]
}

struct TimetableWeekOptions {
    static var list = [
        MenuOptionModel(id: 1, name: "Поиск"),
        MenuOptionModel(id: 2, name: "Псевдонимы"),
        MenuOptionModel(id: 3, name: "AR режим"),
        MenuOptionModel(id: 4, name: "Нужное здание"),
        MenuOptionModel(id: 5, name: "Группы"),
        MenuOptionModel(id: 6, name: "Преподаватели"),
        MenuOptionModel(id: 7, name: "Аудитории"),
        MenuOptionModel(id: 8, name: "День"),
        MenuOptionModel(id: 9, name: "Избранное"),
        MenuOptionModel(id: 10, name: "Фильтрация"),
        MenuOptionModel(id: 11, name: "Сохранить"),
        MenuOptionModel(id: 12, name: "Навигация"),
        MenuOptionModel(id: 13, name: "Голосовые команды"),
        MenuOptionModel(id: 14, name: "Анализ расписания"),
        MenuOptionModel(id: 15, name: "Поделиться")
    ]
}

struct TimetableAROptions {
    static var list = [
        MenuOptionModel(id: 1, name: "Поиск"),
        MenuOptionModel(id: 2, name: "Нужное здание"),
        MenuOptionModel(id: 3, name: "Группы"),
        MenuOptionModel(id: 4, name: "Преподаватели"),
        MenuOptionModel(id: 5, name: "Аудитории"),
        MenuOptionModel(id: 6, name: "Аудитории"),
        MenuOptionModel(id: 7, name: "Избранное"),
        MenuOptionModel(id: 8, name: "Список дней"),
        MenuOptionModel(id: 9, name: "Недели"),
        MenuOptionModel(id: 10, name: "Календарь"),
        MenuOptionModel(id: 11, name: "Навигация"),
        MenuOptionModel(id: 12, name: "Голосовые команды"),
        MenuOptionModel(id: 13, name: "Поделиться")
    ]
}

struct TimetableDateOptions {
    static var list = [
        MenuOptionModel(id: 1, name: "Поиск"),
        MenuOptionModel(id: 2, name: "Обновить"),
        MenuOptionModel(id: 3, name: "AR режим"),
        MenuOptionModel(id: 4, name: "Нужное здание"),
        MenuOptionModel(id: 5, name: "Группы"),
        MenuOptionModel(id: 6, name: "Подгруппы"),
        MenuOptionModel(id: 7, name: "Преподаватели"),
        MenuOptionModel(id: 8, name: "Аудитории"),
        MenuOptionModel(id: 9, name: "Избранное"),
        MenuOptionModel(id: 10, name: "Фильтрация"),
        MenuOptionModel(id: 11, name: "Сохранить"),
        MenuOptionModel(id: 12, name: "Поделиться")
    ]
}

struct NewsOptions {
    static var list = [
        MenuOptionModel(id: 1, name: "Поиск"),
        MenuOptionModel(id: 2, name: "Категории"),
        MenuOptionModel(id: 3, name: "Что нового?"),
        MenuOptionModel(id: 4, name: "Страницы"),
        MenuOptionModel(id: 5, name: "Недавние"),
        MenuOptionModel(id: 6, name: "Вид"),
        MenuOptionModel(id: 7, name: "Фильтрация"),
        MenuOptionModel(id: 8, name: "Рандомайзер"),
        MenuOptionModel(id: 9, name: "Выбрать"),
        MenuOptionModel(id: 10, name: "Голосовые команды"),
        MenuOptionModel(id: 11, name: "Настройки"),
    ]
}

struct MenuScreensCategoryModel {
    let icon: String
    let name: String
    let screens: [menuCategoryScreens]
}

struct MenuScreensCategories {
    static let categories =
    [
        MenuScreensCategoryModel(
            icon: "clock",
            name: "Расписание", screens:
            [menuCategoryScreens.timetableDay,
             menuCategoryScreens.timetableWeek,
             menuCategoryScreens.timetableAR,
             menuCategoryScreens.timetableDate
            ]
        ),
        MenuScreensCategoryModel(
            icon: "news",
            name: "Новости", screens:
            [menuCategoryScreens.newsList]
        )
    ]
}

enum menuCategoryScreens: String, CaseIterable {
    
    case timetableDay = "timetable day"
    case timetableWeek = "timetable week"
    case timetableAR = "timetable AR"
    case timetableDate = "timetable date"
    case newsList = "news list"
    
    var title: String {
        switch self {
        case .timetableDay:
            return "Расписание на день"
        case .timetableWeek:
            return "Расписание на неделю"
        case .timetableAR:
            return "AR-расписание"
        case .timetableDate:
            return "Расписание на дату"
        case .newsList:
            return "Список новостей"
        }
    }
    
    var options: [MenuOptionModel] {
        switch self {
        case .timetableDay:
            return TimetableDayOptions.list
        case .timetableWeek:
            return TimetableWeekOptions.list
        case .timetableAR:
            return TimetableAROptions.list
        case .timetableDate:
            return TimetableDateOptions.list
        case .newsList:
            return NewsOptions.list
        }
    }
}
