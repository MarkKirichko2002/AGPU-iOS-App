//
//  TimeTable.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation

struct TimeTable: Codable {
    let date, time, name, teacherName: String
    let audienceID: String
    let subgroup: Int

    enum CodingKeys: String, CodingKey {
        case date, time, name, teacherName
        case audienceID = "audienceId"
        case subgroup
    }
}
