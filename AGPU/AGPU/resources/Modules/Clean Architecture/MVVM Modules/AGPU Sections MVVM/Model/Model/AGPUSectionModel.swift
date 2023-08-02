//
//  AGPUSectionModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import Foundation

struct AGPUSectionModel {
    let id: Int
    let name: String
    let icon: String
    let url: String
    let subsections: [AGPUSubSectionModel]
    var voiceCommand: String
}
