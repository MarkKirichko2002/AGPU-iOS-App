//
//  RecentPageModel.swift
//  AGPU
//
//  Created by Марк Киричко on 09.07.2023.
//

import Foundation

struct RecentPageModel: Codable {
    let date: String
    let time: String
    let url: String
    let position: CGPoint
}
