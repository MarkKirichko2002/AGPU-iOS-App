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
            url: "http://test.agpu.net/",
            subsections: AGPUSubSections.subsections["Главное"]!,
            voiceCommand: "главное"
        ),
        
        AGPUSectionModel(
            id: 1, name: "Университет",
            icon: "university",
            url: "http://test.agpu.net/struktura-vuza/universitet.php",
            subsections: AGPUSubSections.subsections["Университет"]!,
            voiceCommand: "универ"
        ),
        
        AGPUSectionModel(
            id: 2, name: "Абитуриенту",
            icon: "user",
            url: "http://test.agpu.net/abitur/index.php",
            subsections: AGPUSubSections.subsections["Абитуриенту"]!,
            voiceCommand: "абитуриент"
        ),
        
        AGPUSectionModel(
            id: 3, name: "Студенту",
            icon: "student",
            url: "http://test.agpu.net/studentu/index.php",
            subsections: AGPUSubSections.subsections["Студенту"]!,
            voiceCommand: "студент"
        ),
        
        AGPUSectionModel(
            id: 4,
            name: "Сотрудникам",
            icon: "people",
            url: "http://test.agpu.net/sotrudnikam/index.php",
            subsections: AGPUSubSections.subsections["Сотрудникам"]!,
            voiceCommand: "сотрудник"
        ),
        
        AGPUSectionModel(
            id: 5,
            name: "Наука",
            icon: "science",
            url: "http://test.agpu.net/nauka/index.php",
            subsections: AGPUSubSections.subsections["Наука"]!,
            voiceCommand: "наук"
        ),
        
        AGPUSectionModel(
            id: 6,
            name: "Партнерам",
            icon: "paper plane",
            url: "http://test.agpu.net/partneram/index.php",
            subsections: AGPUSubSections.subsections["Партнерам"]!,
            voiceCommand: "партнёр"
        ),
        
        AGPUSectionModel(
            id: 7,
            name: "МД",
            icon: "world",
            url: "http://test.agpu.net/mezhdunarodnaya-deyatelnost/index.php",
            subsections: AGPUSubSections.subsections["Международная деятельность"]!,
            voiceCommand: "международная деятельность"
        ),
        
        AGPUSectionModel(
            id: 8,
            name: "Безопасность",
            icon: "security",
            url: "http://test.agpu.net/bezopasnost/index.php",
            subsections: AGPUSubSections.subsections["Безопасность"]!,
            voiceCommand: "безопасност"
        )
    ]
}
