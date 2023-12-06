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

enum PairType: String, Codable {
    case lec
    case prac
    case exam
    case lab
    case hol
    case cred
    case fepo
    case cons
    case none
    case all
    
    var title: String {
        switch self {
        case .lec:
            return "лекция"
        case .prac:
            return "практика"
        case .exam:
            return "экзамен"
        case .lab:
            return "лабораторная работа"
        case .hol:
            return "каникулы"
        case .cred:
            return "зачет"
        case .fepo:
            return "ФЭПО"
        case .cons:
            return "консультация"
        case .none:
            return "другое"
        case .all:
            return "все"
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
        case .none:
            return UIColor.white
        case .all:
            return UIColor.white
        }
    }
}
