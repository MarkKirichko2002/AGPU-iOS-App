//
//  AGPUSections.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import Foundation

struct AGPUSections {
    static let sections = [
        AGPUSectionModel(id: 0, name: "Главное", subsections: AGPUSubSections.subsections["Главное"]!, voiceCommand: "главное"),
        AGPUSectionModel(id: 1, name: "Университет", subsections: AGPUSubSections.subsections["Университет"]!, voiceCommand: "универ"),
        AGPUSectionModel(id: 2, name: "Абитуриенту", subsections: AGPUSubSections.subsections["Абитуриенту"]!, voiceCommand: "абитуриент"),
        AGPUSectionModel(id: 3, name: "Студенту", subsections: AGPUSubSections.subsections["Студенту"]!, voiceCommand: "студент"),
        AGPUSectionModel(id: 4, name: "Сотрудникам", subsections: AGPUSubSections.subsections["Сотрудникам"]!, voiceCommand: "сотрудник"),
        AGPUSectionModel(id: 5, name: "Наука", subsections: AGPUSubSections.subsections["Наука"]!, voiceCommand: "наук"),
    AGPUSectionModel(id: 6, name: "Партнерам", subsections: AGPUSubSections.subsections["Партнерам"]!, voiceCommand: "партнёр"),
        AGPUSectionModel(id: 7, name: "Международная деятельность", subsections: AGPUSubSections.subsections["Международная деятельность"]!, voiceCommand: "отдел международной деятельности"),
        AGPUSectionModel(id: 8, name: "Безопасность", subsections: AGPUSubSections.subsections["Безопасность"]!, voiceCommand: "безопасность")
    ]
}
