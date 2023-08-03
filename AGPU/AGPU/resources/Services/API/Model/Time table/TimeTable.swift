//
//  TimeTable.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation

struct TimeTable: Codable {
    let date, time, name: String
    let type: PairType
    let teacherName, audienceID: String?
    let subgroup: Int
    let groupName: String

    enum CodingKeys: String, CodingKey {
        case date, time, name, type, teacherName
        case audienceID = "audienceId"
        case subgroup, groupName
    }
}

enum PairType: String, Codable {
    case lec
    case prac
    case exam
    case lab
    case hol
    case cred
    case none
}
