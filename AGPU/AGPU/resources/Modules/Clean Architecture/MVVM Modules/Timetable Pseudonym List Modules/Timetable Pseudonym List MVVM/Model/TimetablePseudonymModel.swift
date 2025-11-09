//
//  TimetablePseudonymModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.10.2025.
//

import Foundation

struct TimetablePseudonymModel: Codable {
    let originalName: String
    var pseudonym: String
}

struct WeekDaysPseudonyms {
    static var weekDays = [
        TimetablePseudonymModel(originalName: "Пн", pseudonym: "Пн"),
        TimetablePseudonymModel(originalName: "Вт", pseudonym: "Вт"),
        TimetablePseudonymModel(originalName: "Ср", pseudonym: "Ср"),
        TimetablePseudonymModel(originalName: "Чт", pseudonym: "Чт"),
        TimetablePseudonymModel(originalName: "Пт", pseudonym: "Пт"),
        TimetablePseudonymModel(originalName: "Сб", pseudonym: "Сб"),
        TimetablePseudonymModel(originalName: "Вс", pseudonym: "Вс")
    ]
}
