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
            name: "личный кабинет ЭИОС"
        ),
        ForEveryStatusModel(
            id: 2,
            icon: "map icon",
            name: "найти «АГПУ»"
        ),
        ForEveryStatusModel(
            id: 3,
            icon: "online",
            name: "ведомости online"
        ),
        ForEveryStatusModel(
            id: 4,
            icon: "book",
            name: "методические материалы"
        ),
        ForEveryStatusModel(
            id: 5,
            icon: "group icon",
            name: "подразделения"
        ),
        ForEveryStatusModel(
            id: 6,
            icon: "document",
            name: "документы"
        ),
        ForEveryStatusModel(
            id: 7,
            icon: "sections icon",
            name: "разделы"
        )
    ]
}
