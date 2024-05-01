//
//  SearchTimetableModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.01.2024.
//

import RealmSwift
import Foundation

class SearchTimetableModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var owner: String
}

