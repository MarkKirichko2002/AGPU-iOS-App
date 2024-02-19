//
//  DocumentModel.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import RealmSwift

class DocumentModel: Object {
    @Persisted var name: String
    @Persisted var format: String
    @Persisted(primaryKey: true) var url: String
}
