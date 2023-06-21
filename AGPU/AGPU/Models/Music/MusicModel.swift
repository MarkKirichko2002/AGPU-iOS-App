//
//  MusicModel.swift
//  AGPU
//
//  Created by Марк Киричко on 20.06.2023.
//

import Foundation

struct MusicModel: Codable {
    let id: Int
    let name: String
    let fileName: String
    var isChecked: Bool
    
    mutating func setDone() {
        isChecked.toggle()
    }
}
