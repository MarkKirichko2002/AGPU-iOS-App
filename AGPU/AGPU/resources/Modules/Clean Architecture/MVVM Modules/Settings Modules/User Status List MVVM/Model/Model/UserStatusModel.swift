//
//  UserStatusModel.swift
//  AGPU
//
//  Created by Марк Киричко on 27.07.2023.
//

import Foundation

struct UserStatusModel: Codable {
    let id: Int
    let name: String
    let icon: String
    var isSelected: Bool
}
