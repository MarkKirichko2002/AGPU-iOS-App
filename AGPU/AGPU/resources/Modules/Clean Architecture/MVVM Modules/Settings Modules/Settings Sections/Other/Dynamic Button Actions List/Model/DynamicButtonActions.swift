//
//  DynamicButtonActions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import Foundation

enum DynamicButtonActions: String, CaseIterable, Codable {
    case speechRecognition = "Распознавание речи"
    case timetableWeeks = "Расписание на неделю"
    case campusMap = "Карта кампуса"
    case studyPlan = "Учебный план"
    case profile = "Личный кабинет ЭИОС"
    case manual = "Методические материалы"
}
