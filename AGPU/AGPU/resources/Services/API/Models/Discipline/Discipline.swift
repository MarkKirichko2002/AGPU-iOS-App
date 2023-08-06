//
//  Discipline.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation

struct Discipline: Codable {
    let time: String
    let name, teacherName, audienceID: String
    let subgroup: Int
    let type: PairType

    enum CodingKeys: String, CodingKey {
        case time, name, teacherName
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
}
