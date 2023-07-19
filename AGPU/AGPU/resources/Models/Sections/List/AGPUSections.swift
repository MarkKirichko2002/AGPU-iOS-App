//
//  AGPUSections.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import Foundation

struct AGPUSections {
    static let sections = [
        AGPUSectionModel(
            id: 0,
            name: "Главное",
            icon: "home icon",
            subsections: AGPUSubSections.subsections["Главное"]!,
            voiceCommand: "главное"
        ),
        AGPUSectionModel(
            id: 1, name: "Университет",
            icon: "university",
            subsections: AGPUSubSections.subsections["Университет"]!,
            voiceCommand: "универ"
        ),
        AGPUSectionModel(
            id: 2, name: "Абитуриенту",
            icon: "user",
            subsections: AGPUSubSections.subsections["Абитуриенту"]!,
            voiceCommand: "абитуриент"
        ),
        AGPUSectionModel(
            id: 3, name: "Студенту",
            icon: "student",
            subsections: AGPUSubSections.subsections["Студенту"]!,
            voiceCommand: "студент"
        ),
        AGPUSectionModel(
            id: 4,
            name: "Сотрудникам",
            icon: "people",
            subsections: AGPUSubSections.subsections["Сотрудникам"]!,
            voiceCommand: "сотрудник"
        ),
        AGPUSectionModel(
            id: 5,
            name: "Наука",
            icon: "science",
            subsections: AGPUSubSections.subsections["Наука"]!,
            voiceCommand: "наук"
        ),
        AGPUSectionModel(
            id: 6,
            name: "Партнерам",
            icon: "paper plane",
            subsections: AGPUSubSections.subsections["Партнерам"]!,
            voiceCommand: "партнёр"
        ),
        AGPUSectionModel(
            id: 7,
            name: "Международная деятельность",
            icon: "world",
            subsections: AGPUSubSections.subsections["Международная деятельность"]!,
            voiceCommand: "международная деятельность"
        ),
        AGPUSectionModel(
            id: 8,
            name: "Безопасность",
            icon: "security",
            subsections: AGPUSubSections.subsections["Безопасность"]!,
            voiceCommand: "безопасность"
        )
    ]
}
