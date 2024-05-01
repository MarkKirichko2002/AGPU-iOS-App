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
    
    // MARK: - Important Documents
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
    
    // MARK: - Adaptive News
    func saveArticle(model: NewsModel) {
        let article = realm.object(ofType: NewsModel.self, forPrimaryKey: model.id)
        if article == nil {
            let newArticle = NewsModel()
            newArticle.id = model.id
            newArticle.title = model.title
            newArticle.articleDescription = model.articleDescription
            newArticle.url = model.url
            newArticle.offsetY = 0
            newArticle.previewImage = model.previewImage
            newArticle.date = model.date
            
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
    
    func getArticles()-> [NewsModel] {
        let items = realm.objects(NewsModel.self)
        return Array(items)
    }
    
    func editArticle(news: NewsModel, position: Double) {
        let newArticle = realm.object(ofType: NewsModel.self, forPrimaryKey: news.id)
        try! realm.write {
            newArticle?.offsetY = position
        }
    }
    
    func deleteArticle(news: NewsModel) {
        let article = realm.object(ofType: NewsModel.self, forPrimaryKey: news.id)
        guard let article = article else {return}
        try! realm.write {
            realm.delete(article)
        }
    }
    
    // MARK: - My Splash Screen
    func saveSplashScreen(screen: CustomSplashScreenModel) {
        
        let newScreen = CustomSplashScreenModel()
        newScreen.id = 1
        newScreen.image = screen.image
        newScreen.title = screen.title
        newScreen.color = screen.color
        
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
    
    func getSplashScreen()-> CustomSplashScreenModel {
        let defaultScreen = CustomSplashScreenModel()
        defaultScreen.image = UIImage(named: "АГПУ")?.pngData()
        defaultScreen.title = "Ваш Текст"
        let splashScreen = realm.object(ofType: CustomSplashScreenModel.self, forPrimaryKey: 1) ?? defaultScreen
        return splashScreen
    }
    
    func saveTimetableItem(item: SearchTimetableModel) {
        let a = realm.object(ofType: SearchTimetableModel.self, forPrimaryKey: item.id)
        if a == nil {
            let newItem = SearchTimetableModel()
            newItem.id = item.id
            newItem.name = item.name
            newItem.owner = item.owner
            try! realm.write {
                realm.add(newItem)
            }
        } else {
            print("уже есть")
        }
    }
    
    func deleteTimetableItem(item: SearchTimetableModel) {
        let item = realm.object(ofType: SearchTimetableModel.self, forPrimaryKey: item.id)
        guard let item = item else {return}
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func getTimetableItems()->[SearchTimetableModel] {
        let items = realm.objects(SearchTimetableModel.self)
        return Array(items)
    }
}
