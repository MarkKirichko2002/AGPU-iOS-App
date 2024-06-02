//
//  VideoModel.swift
//  AGPU
//
//  Created by Марк Киричко on 02.06.2024.
//

import RealmSwift

class VideoModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var date: String
    @Persisted var url: String
}
