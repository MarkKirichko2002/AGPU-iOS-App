//
//  TimeTable.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

struct TimeTable: Codable {
    
    let date, groupName: String
    var disciplines: [Discipline]
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case groupName
        case disciplines = "disciplines"
    }
}
