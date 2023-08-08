//
//  NewsModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

struct NewsModel: Codable {
    let id: Int
    let title: String?
    let description: String?
    let date: String?
    let previewImage: String?
}
