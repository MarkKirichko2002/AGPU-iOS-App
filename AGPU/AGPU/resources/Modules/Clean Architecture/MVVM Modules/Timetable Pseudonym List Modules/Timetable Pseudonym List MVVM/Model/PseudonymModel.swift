//
//  PseudonymModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.10.2025.
//

import Foundation

struct PseudonymModel: Codable {
    let originalName: String
    var pseudonym: String
}

struct WeekDaysPseudonyms {
    static var weekDays = [
        PseudonymModel(originalName: "Пн", pseudonym: "Пн"),
        PseudonymModel(originalName: "Вт", pseudonym: "Вт"),
        PseudonymModel(originalName: "Ср", pseudonym: "Ср"),
        PseudonymModel(originalName: "Чт", pseudonym: "Чт"),
        PseudonymModel(originalName: "Пт", pseudonym: "Пт"),
        PseudonymModel(originalName: "Сб", pseudonym: "Сб"),
        PseudonymModel(originalName: "Вс", pseudonym: "Вс")
    ]
}

struct BuildingPseudonyms {
    static var buldings = AGPUBuildings.buildings.map({
        PseudonymModel(originalName: $0.name, pseudonym: $0.name)
    })
}
