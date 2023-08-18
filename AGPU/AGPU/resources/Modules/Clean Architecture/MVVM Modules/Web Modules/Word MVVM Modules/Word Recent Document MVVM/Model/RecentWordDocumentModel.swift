//
//  RecentWordDocumentModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import Foundation

struct RecentWordDocumentModel: Codable {
    let date: String
    let time: String
    let url: String
    let position: CGPoint
}

