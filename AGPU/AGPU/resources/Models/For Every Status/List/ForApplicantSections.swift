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
            name: "личный кабинет абитуриента"
        ),
        ForEveryStatusModel(
            id: 2,
            icon: "map icon",
            name: "найти «АГПУ»"
        ),
        ForEveryStatusModel(
            id: 3,
            icon: "university",
            name: "институты/факультета"
        ),
        ForEveryStatusModel(
            id: 4,
            icon: "info icon",
            name: "информация для поступающих"
        ),
        ForEveryStatusModel(
            id: 5,
            icon: "question",
            name: "вопросы и ответы"
        ),
        ForEveryStatusModel(
            id: 6,
            icon: "plus",
            name: "дополнительное образование"
        )
    ]
}
