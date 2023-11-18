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
            icon: "profile icon",
            name: "Личный кабинет абитуриента"
        ),
        ForEveryStatusModel(
            id: 2,
            icon: "map icon",
            name: "Найти «АГПУ»"
        ),
        ForEveryStatusModel(
            id: 3,
            icon: "university",
            name: "Институты/факультета"
        ),
        ForEveryStatusModel(
            id: 4,
            icon: "info icon",
            name: "Информация для поступающих"
        ),
        ForEveryStatusModel(
            id: 5,
            icon: "question",
            name: "Вопросы и ответы"
        ),
        ForEveryStatusModel(
            id: 6,
            icon: "plus",
            name: "Дополнительное образование"
        ),
        ForEveryStatusModel(
            id: 7,
            icon: "sections",
            name: "Разделы сайта"
        ),
    ]
}
