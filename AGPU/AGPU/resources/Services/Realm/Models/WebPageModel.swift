//
//  WebPageModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.04.2025.
//

import RealmSwift

class WebPageModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var url: String
}
