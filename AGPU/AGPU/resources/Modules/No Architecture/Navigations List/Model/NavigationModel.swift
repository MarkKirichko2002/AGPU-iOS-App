//
//  NavigationModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.01.2025.
//

import Foundation

struct NavigationModel {
    let name: String
    let description: String
}

enum NavigationScreen {
    
    case timetableDay
    case timetableWeek
    case timetableAR
    
    var ways: [NavigationModel] {
        switch self {
        case .timetableDay:
            return Navigations.timetableDayWays
        case .timetableWeek:
            return Navigations.timetableWeekWays
        case .timetableAR:
            return Navigations.timetableAR
        }
    }
}

struct Navigations {
    
    static let timetableDayWays = [
        NavigationModel(name: "Список дней", description: "Выбор ближайшего дня из списка"),
        NavigationModel(name: "Боковое меню", description: "Выбор дня текущей/следующей недели"),
        NavigationModel(name: "Голосовые команды", description: "При нажатии на эту ячейку откроется список"),
        NavigationModel(name: "\"Плавающая\" кнопка", description: "Навигационная панель - при нажатии на кнопку в верхней части появится навигационное меню,\nКонтекстное меню - выбор типа навигации для даты в расписании (день, месяц, год)"),
        NavigationModel(name: "Кнопка \"Обновить\"", description: "Простое нажатие - обновить расписание,\nДолгое нажатие - расписание на текущую дату"),
        NavigationModel(name: "Поворот экрана", description: "Горизонтально влево - прошлый день,\nЛицом вниз - текущий день,\nГоризонтально право - следующий день"),
        NavigationModel(name: "Уровень громкости", description: "0% - прошлый день,\n50% - настоящий день,\n100% - следующий день"),
        NavigationModel(name: "Жесты руки", description: "Один палец - прошлый день,\nПять пальцев - настоящий день,\nДва пальца - следующий день,\nКулак - обновить расписание,\nПалец вверх - добавить в список избранное,\nПалец вниз - убрать из списка избранное"),
        NavigationModel(name: "Свайпы по навигационной панели", description: "Влево - прошлый день,\nВправо - следующий день")
    ]
    
    static let timetableWeekWays = [
        NavigationModel(name: "Список дней", description: "Выбор дня недели из списка"),
        NavigationModel(name: "Голосовые команды", description: "При нажатии на эту ячейку откроется список"),
        NavigationModel(name: "Навигационное меню", description: "При нажатии на \"плавающую\" кнопку в верхней части появится навигационное меню"),
        NavigationModel(name: "Поворот экрана", description: "Горизонтально влево - прошлая неделя,\nЛицом вниз - текущая неделя,\nГоризонтально право - следующая неделя"),
        NavigationModel(name: "Уровень громкости", description: "0% - прошлая неделя,\n50% - текущая неделя,\n100% - следующая неделя"),
        NavigationModel(name: "Жесты руки", description: "Один палец - прошлая неделя,\nПять пальцев - текущая неделя,\nДва пальца - следующая неделя,\nКулак - обновить расписание,\nПалец вверх - добавить в список избранное,\nПалец вниз - убрать из списка избранное"),
        NavigationModel(name: "Свайпы по навигационной панели", description: "Влево - прошлая неделя,\nВправо - следующая неделя")
    ]
    
    static let timetableAR = [
        NavigationModel(name: "Свайпы", description: "Влево - прошлый день/неделя,\nВправо - следующий день/неделя"),
        NavigationModel(name: "Голосовые команды", description: "При нажатии на эту ячейку откроется список")
    ]
}
                        
