//
//  TabModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

struct TabModel: Codable, Equatable {
    let id: Int
    var name: String
    var icon = UIImage().pngData()
    var position: Int
}
