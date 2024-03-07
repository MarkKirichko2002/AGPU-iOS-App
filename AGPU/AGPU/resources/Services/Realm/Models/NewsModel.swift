//
//  NewsModel.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import RealmSwift

class NewsModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var offsetY: Double
}
