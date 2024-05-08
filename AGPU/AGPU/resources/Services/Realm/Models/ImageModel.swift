//
//  ImageModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.05.2024.
//

import RealmSwift

class ImageModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var image: Data
    @Persisted var date: String
}
