//
//  RealmManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import Foundation

// MARK: - IRealmManager
extension RealmManager: IRealmManager {
    
    func saveDocument(document: DocumentModel) {
        let doc = realm.object(ofType: DocumentModel.self, forPrimaryKey: document.url)
        if doc == nil {
            let newDocument = DocumentModel()
            newDocument.name = document.name
            newDocument.format = document.format
            newDocument.url = document.url
            try! realm.write {
                realm.add(newDocument)
            }
        } else {
            print("уже есть")
        }
    }
    
    func editDocument(document: DocumentModel, name: String) {
        let newDocument = realm.object(ofType: DocumentModel.self, forPrimaryKey: document.url)
        try! realm.write {
            newDocument?.name = name
        }
    }
    
    func deleteDocument(document: DocumentModel) {
        let newDocument = realm.object(ofType: DocumentModel.self, forPrimaryKey: document.url)
        guard let newDocument = newDocument else {return}
        try! realm.write {
            realm.delete(newDocument)
        }
    }
    
    func getDocuments() -> [DocumentModel] {
        var array = [DocumentModel]()
        let items = realm.objects(DocumentModel.self)
        for item in items {
            array.append(item)
        }
        return array
    }
}
