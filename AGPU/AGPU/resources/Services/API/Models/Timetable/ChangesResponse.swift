//
//  ChangesResponse.swift
//  AGPU
//
//  Created by Марк Киричко on 09.10.2023.
//

import Foundation

struct ChangesResponse: Codable {
    let thereAreChanges: Bool
    let date: String
}
