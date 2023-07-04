//
//  ElectedFacultyModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2023.
//

import Foundation

struct ElectedFacultyModel: Codable {
    let id: Int
    let name: String
    let icon: String
    let appIcon: String
    let url: String
    let phoneNumbers: [String]
    var isSelected = false
}
