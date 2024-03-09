//
//  TimeTable.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

struct TimeTable: Codable {
    
    let id, date: String
    var disciplines: [Discipline]
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "date"
        case disciplines = "disciplines"
    }
}
