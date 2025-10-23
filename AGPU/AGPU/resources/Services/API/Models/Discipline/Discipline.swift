//
//  Discipline.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

struct Discipline: Codable, Hashable {
    
    var time: String
    var name, groupName, teacherName, audienceID: String
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
            return "Лаб. работа"
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
    
    var voiceCommand: String {
        switch self {
        case .lec:
            return "лекци"
        case .prac:
            return "практик"
        case .exam:
            return "экзам"
        case .lab:
            return "лаб"
        case .hol:
            return "каникул"
        case .cred:
            return "зачет"
        case .fepo:
            return "фэпо"
        case .cons:
            return "консульта"
        case .cours:
            return "курсов"
        case .none:
            return "другое"
        case .leftToday:
            return "..."
        case .all:
            return "..."
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
            return UIColor.white
        case .cred:
            return UIColor.white
        case .fepo:
            return UIColor.white
        case .cons:
            return UIColor.white
        case .cours:
            return UIColor.white
        case .none:
            return UIColor.white
        case .leftToday:
            return UIColor.white
        case .all:
            return UIColor.white
        }
    }
}
