//
//  NewsResponse.swift
//  AGPU
//
//  Created by Марк Киричко on 09.08.2023.
//

import Foundation

struct NewsResponse: Codable {
    var currentPage, countPages: Int?
    var articles: [Article]?
}
