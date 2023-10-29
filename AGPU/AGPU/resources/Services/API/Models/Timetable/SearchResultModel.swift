//
//  SearchResultModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.10.2023.
//

import Foundation

// MARK: - SearchResultModel
struct SearchResultModel: Codable {
    let searchContent: String
    let searchID, ownerID: Int
    let type: SearchType

    enum CodingKeys: String, CodingKey {
        case searchContent = "SearchContent"
        case type = "Type"
        case searchID = "SearchId"
        case ownerID = "OwnerId"
    }
}

enum SearchType: String, Codable {
    case Teacher
    case Group
    case Classroom
}
