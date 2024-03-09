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
        
        print("\(index) and \(index2)")
        
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
        let items = realm.objects(DocumentModel.self)
        return Array(items)
    }
    
    func saveArticle(news: Article, model: NewsModel) {
        let article = realm.object(ofType: NewsModel.self, forPrimaryKey: model.id)
        if article == nil {
            let newArticle = NewsModel()
            newArticle.id = news.id
            newArticle.offsetY = 0
            try! realm.write {
                realm.add(newArticle)
            }
        } else {
            print("уже есть")
        }
    }
    
    func getArticle(id: Int)-> NewsModel? {
        let article = realm.object(ofType: NewsModel.self, forPrimaryKey: id)
        return article
    }
    
    func editArticle(news: NewsModel, position: Double) {
        let newArticle = realm.object(ofType: NewsModel.self, forPrimaryKey: news.id)
        try! realm.write {
            newArticle?.offsetY = position
        }
    }
    
    func saveSplashScreen(screen: CustomSplashScreenModel) {
        
        let newScreen = CustomSplashScreenModel()
        newScreen.id = 1
        newScreen.image = screen.image
        newScreen.title = screen.title
        
        if let oldScreen = realm.object(ofType: CustomSplashScreenModel.self, forPrimaryKey: 1) {
            try! realm.write {
                realm.delete(oldScreen)
            }
            try! realm.write {
                realm.add(newScreen)
            }
        } else {
            try! realm.write {
                realm.add(newScreen)
            }
        }
    }
    
    func getSplashScreen()-> CustomSplashScreenModel? {
        let splashScreen = realm.object(ofType: CustomSplashScreenModel.self, forPrimaryKey: 1)
        return splashScreen
    }
}
