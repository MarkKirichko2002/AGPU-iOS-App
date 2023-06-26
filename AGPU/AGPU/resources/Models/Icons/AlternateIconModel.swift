//
//  AlternateIconModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2023.
//

import Foundation

struct AlternateIconModel: Codable {
    let id: Int
    let name: String
    let icon: String
    let appIcon: String
    var isSelected = false
}
