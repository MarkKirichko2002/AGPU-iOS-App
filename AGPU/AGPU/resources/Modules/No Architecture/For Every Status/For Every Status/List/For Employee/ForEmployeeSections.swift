//
//  ForEmployeeSections.swift
//  AGPU
//
//  Created by Марк Киричко on 27.07.2023.
//

import Foundation

struct ForEmployeeSections {
    
    static let sections = [
        
        ForEveryStatusModel(
            id: 1,
            icon: "profile icon",
            name: "Личный кабинет ЭИОС"
        ),
        ForEveryStatusModel(
            id: 2,
            icon: "map icon",
            name: "Найти кампус"
        ),
        ForEveryStatusModel(
            id: 3,
            icon: "online",
            name: "Ведомости online"
        ),
        ForEveryStatusModel(
            id: 4,
            icon: "book",
            name: "Методические материалы"
        ),
        ForEveryStatusModel(
            id: 5,
            icon: "exclamation",
            name: "Важные вещи"
        ),
        ForEveryStatusModel(
            id: 6,
            icon: "student",
            name: "Учебный план"
        ),
        ForEveryStatusModel(
            id: 7,
            icon: "sections icon",
            name: "Разделы сайта"
        ),
        ForEveryStatusModel(
            id: 8,
            icon: "photo icon",
            name: "АГПУ обои"
        )
    ]
}
