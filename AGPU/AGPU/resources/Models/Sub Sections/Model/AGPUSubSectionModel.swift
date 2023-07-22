//
//  AGPUSubSectionModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import Foundation

struct AGPUSubSectionModel: Codable {
    let id: Int
    let name: String
    let icon: String
    let url: String
    var voiceCommand: String
}
