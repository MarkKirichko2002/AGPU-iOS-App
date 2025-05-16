//
//  VoiceCommands.swift
//  AGPU
//
//  Created by Марк Киричко on 18.12.2024.
//

import Foundation

struct VoiceCommandItem {
    let name: String
    let description: String
}

enum VoiceCommandsType {
    case main
    case timetableDay
    case timetableWeek
    case pairInfo
    case newsList
    case timetableAR
    case newsAR
    
    var commands: [VoiceCommandItem] {
        switch self {
        case .main:
            return VoiceCommands.commands
        case .timetableDay:
            return VoiceCommands.timetableDay
        case .timetableWeek:
            return VoiceCommands.timetableWeek
        case .pairInfo:
            return VoiceCommands.pairInfo
        case .newsList:
            return VoiceCommands.newsList
        case .timetableAR:
            return VoiceCommands.timetableAR
        case .newsAR:
            return VoiceCommands.newsAR
        }
    }
}

struct VoiceCommands {
    
    static let commands = [
        VoiceCommandItem(name: "Название корпуса", description: "Открывает карту с меткой названного корпуса"),
        VoiceCommandItem(name: "Название раздела сайта", description: "Открывает веб-страницу раздела сайта"),
        VoiceCommandItem(name: "Случайный раздел", description: "Открывает случайную веб-страницу раздела сайта"),
        VoiceCommandItem(name: "Вверх/Вниз", description: "Прокручивает веб-страницу сайт вверх или вниз"),
        VoiceCommandItem(name: "Недели", description: "Открывает список недель для расписания"),
        VoiceCommandItem(name: "Закрыть", description: "Закрывает экран"),
        VoiceCommandItem(name: "Стоп", description: "Выключает микрофон"),
    ]
    static let timetableDay = [
        VoiceCommandItem(name: "Сегодня", description: "Показывает расписание на сегодня"),
        VoiceCommandItem(name: "Завтра", description: "Показывает расписание на завтра"),
        VoiceCommandItem(name: "Вчера", description: "Показывает расписание за вчера"),
        VoiceCommandItem(name: "Вперед", description: "Показывает расписание на следующую дату"),
        VoiceCommandItem(name: "Назад", description: "Показывает расписание на предыдущую дату"),
        VoiceCommandItem(name: "День недели", description: "Показывает расписание на выбранный день недели"),
        VoiceCommandItem(name: "Текущая неделя", description: "Сбрасывает неделю до текущей"),
        VoiceCommandItem(name: "Дата (день месяц)", description: "Показывает расписание на выбранную дату"),
        VoiceCommandItem(name: "N-я пара", description: "Показывает пару по номеру"),
        VoiceCommandItem(name: "Название типа пары", description: "Показывает отфильтрованный по типу пары список пар"),
        VoiceCommandItem(name: "Название корпуса", description: "Показывает отфильтрованный по корпусу список пар"),
        VoiceCommandItem(name: "Сколько всего пар?", description: "Показывает количество всех пар на выбранную дату"),
        VoiceCommandItem(name: "Оставшиеся пары/Cколько осталось пар?", description: "Показывает оставшиеся пары на выбранную дату"),
        VoiceCommandItem(name: "Текущая пара/Какая сейчас пара?", description: "Показывает текущую пару"),
        VoiceCommandItem(name: "Следующая пара", description: "Показывает следующую пару"),
        VoiceCommandItem(name: "Предыдущая пара/Прошлая пара", description: "Показывает прошлую пару"),
        VoiceCommandItem(name: "Последняя пара", description: "Показывает последнюю пару"),
        VoiceCommandItem(name: "Закрыть", description: "Закрывает сообщение на экране"),
        VoiceCommandItem(name: "Обновить", description: "Обновляет расписание")
    ]
    static let timetableWeek = [
        VoiceCommandItem(name: "Текущая", description: "Показывает расписание на выбранную неделю"),
        VoiceCommandItem(name: "Вперед", description: "Показывает расписание на следующую неделю"),
        VoiceCommandItem(name: "Назад", description: "Показывает расписание на предыдущую неделю"),
        VoiceCommandItem(name: "День недели", description: "Прокручивает до названного дня недели"),
        VoiceCommandItem(name: "Обновить", description: "Обновляет расписание")
    ]
    static let pairInfo = [
        VoiceCommandItem(name: "Название ячейки", description: "Выделяет выбранную ячейку"),
        VoiceCommandItem(name: "Все", description: "Показывает все ячейки")
    ]
    static let newsList = [
        VoiceCommandItem(name: "Название типа фильтрации", description: "Показывает отфильтрованный по типу фильтрации список новостей"),
        VoiceCommandItem(name: "Название вида новостей", description: "Меняет вид отображения новостей"),
        VoiceCommandItem(name: "Дата (день месяц)", description: "Показывает новости на выбранную дату"),
        VoiceCommandItem(name: "Все новости", description: "Показывает все новости"),
        VoiceCommandItem(name: "Закрыть", description: "Закрывает сообщение на экране"),
        VoiceCommandItem(name: "Обновить", description: "Обновляет список новостей")
    ]
    static let timetableAR = [
        VoiceCommandItem(name: "Сегодня", description: "Показывает расписание на сегодня"),
        VoiceCommandItem(name: "Вперед", description: "Показывает расписание на следующую дату/неделю"),
        VoiceCommandItem(name: "Назад", description: "Показывает расписание на предыдущую дату/неделю"),
        VoiceCommandItem(name: "Дата (день месяц)", description: "Показывает расписание на выбранную дату"),
        VoiceCommandItem(name: "Закрыть", description: "Закрывает сообщение на экране"),
        VoiceCommandItem(name: "Обновить", description: "Обновляет расписание")
    ]
    static let newsAR = [
        VoiceCommandItem(name: "Вперед", description: "Показывает следующее изображение новости"),
        VoiceCommandItem(name: "Назад", description: "Показывает предыдущее изображение новости"),
        VoiceCommandItem(name: "Обновить", description: "Обновляет AR-объект")
    ]
}
