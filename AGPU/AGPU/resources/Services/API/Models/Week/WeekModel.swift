//
//  WeekModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

struct WeekModel: Codable {
    let id: Int
    let from, to: String
    let dayNames: [String: String]
}
