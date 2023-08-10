//
//  Article.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

struct Article: Codable {
    let id: Int
    let title: String?
    let description: String?
    let date: String?
    let previewImage: String?
}
