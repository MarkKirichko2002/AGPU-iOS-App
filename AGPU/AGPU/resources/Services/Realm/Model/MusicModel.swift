//
//  MusicModel.swift
//  AGPU
//
//  Created by Марк Киричко on 20.06.2023.
//

import RealmSwift

class MusicModel: Object, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var fileName: String
    @Persisted var isChecked: Bool
}