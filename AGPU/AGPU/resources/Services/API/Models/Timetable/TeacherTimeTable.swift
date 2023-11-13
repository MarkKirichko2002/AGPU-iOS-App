//
//  TeacherTimeTable.swift
//  AGPU
//
//  Created by Марк Киричко on 28.10.2023.
//

import Foundation

struct TeacherTimeTable: Codable {
    
    let date, teacherName: String
    var disciplines: [Discipline]
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case teacherName
        case disciplines = "disciplines"
    }
}

