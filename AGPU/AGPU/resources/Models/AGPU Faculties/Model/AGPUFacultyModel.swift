//
//  AGPUFacultyModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2023.
//

import Foundation

struct AGPUFacultyModel: Codable {
    let id: Int
    let name: String
    let cathedra: [FacultyCathedraModel]
    let icon: String
    let abbreviation: String
    let appIcon: String
    let url: String
    let newsURL: String
    let videoURL: String
    let contacts: [ContactsModel]
    let email: String
    var isSelected = false
}
