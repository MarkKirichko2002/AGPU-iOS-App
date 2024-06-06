//
//  ContactModel.swift
//  AGPU
//
//  Created by Марк Киричко on 06.06.2024.
//

import RealmSwift

class ContactModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var number: String
}

