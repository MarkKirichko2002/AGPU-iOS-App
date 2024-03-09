//
//  ForApplicantSections.swift
//  AGPU
//
//  Created by Марк Киричко on 26.07.2023.
//

import Foundation

struct ForApplicantSections {
    
    static let sections = [
        ForEveryStatusModel(
            id: 1,
            icon: "map icon",
            name: "Найти кампус"
        ),
        ForEveryStatusModel(
            id: 2,
            icon: "university",
            name: "Институты/факультета"
        ),
        ForEveryStatusModel(
            id: 3,
            icon: "info icon",
            name: "Информация для поступающих"
        ),
        ForEveryStatusModel(
            id: 4,
            icon: "question",
            name: "Вопросы и ответы"
        ),
        ForEveryStatusModel(
            id: 5,
            icon: "plus",
            name: "Дополнительное образование"
        ),
        ForEveryStatusModel(
            id: 6,
            icon: "sections",
            name: "Разделы сайта"
        ),
    ]
}
