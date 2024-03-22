//
//  Discipline.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

struct Discipline: Codable, Hashable {
    
    let time: String
    let name, groupName, teacherName, audienceID: String
    let subgroup: Int
    let type: PairType

    enum CodingKeys: String, CodingKey {
        case time, name, groupName, teacherName
        case audienceID = "audienceId"
        case subgroup, type
    }
}

enum PairType: String, CaseIterable, Codable {
    case lec
    case prac
    case exam
    case lab
    case hol
    case cred
    case fepo
    case cons
    case cours
    case none
    case leftToday
    case all
    
    var title: String {
        switch self {
        case .lec:
            return "Лекция"
        case .prac:
            return "Практика"
        case .exam:
            return "Экзамен"
        case .lab:
            return "Лабораторная работа"
        case .hol:
            return "Каникулы"
        case .cred:
            return "Зачет"
        case .fepo:
            return "ФЭПО"
        case .cons:
            return "Консультация"
        case .cours:
            return "Курсовая"
        case .none:
            return "Другое"
        case .leftToday:
            return "Оставшаяся"
        case .all:
            return "Все"
        }
    }
    
    var color: UIColor {
        switch self {
        case .lec:
            return UIColor(named: "lecture")!
        case .prac:
            return UIColor(named: "prac")!
        case .exam:
            return UIColor(named: "exam")!
        case .lab:
            return UIColor(named: "lab")!
        case .hol:
            return UIColor.label
        case .cred:
            return UIColor.label
        case .fepo:
            return UIColor.label
        case .cons:
            return UIColor.label
        case .cours:
            return UIColor.label
        case .none:
            return UIColor.label
        case .leftToday:
            return UIColor.label
        case .all:
            return UIColor.label
        }
    }
}
