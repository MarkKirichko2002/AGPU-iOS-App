//
//  RealmManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import Foundation
import RealmSwift

// MARK: - IRealmManager
extension RealmManager: IRealmManager {
    
    func saveDocument(document: DocumentModel) {
        let doc = realm.object(ofType: DocumentModel.self, forPrimaryKey: document.url)
        if doc == nil {
            let newDocument = DocumentModel()
            newDocument.name = document.name
            newDocument.format = document.format
            newDocument.url = document.url
            newDocument.page = document.page
            try! realm.write {
                realm.add(newDocument)
            }
        } else {
            print("уже есть")
        }
    }
    
    func editDocumentName(document: DocumentModel, name: String) {
        let newDocument = realm.object(ofType: DocumentModel.self, forPrimaryKey: document.url)
        try! realm.write {
            newDocument?.name = name
        }
    }
    
    func editDocumentPage(url: String, page: Int) {
        let newDocument = realm.object(ofType: DocumentModel.self, forPrimaryKey: url)
        try! realm.write {
            newDocument?.page = page
        }
    }
    
    func updateDocuments(documents: [DocumentModel], _ index: Int, _ index2: Int) {
        
        var arr = [DocumentModel]()
        
        for document in documents {
            let newDocument = DocumentModel()
            newDocument.name = document.name
            newDocument.format = document.format
            newDocument.url = document.url
            newDocument.page = document.page
            arr.append(newDocument)
        }
        
        arr.swapAt(index, index2)
        
        try! realm.write {
            realm.deleteAll()
        }
        
        try! realm.write {
            realm.add(arr)
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
