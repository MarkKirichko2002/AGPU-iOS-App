//
//  ArticleInfo.swift
//  AGPU
//
//  Created by Марк Киричко on 20.08.2024.
//

import Foundation

struct ArticleInfo: Codable {
    let id: Int?
    let title, description, date: String
    let images: [String]
}
