//
//  IRealmManager.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import Foundation

protocol IRealmManager {
    func saveDocument(document: DocumentModel)
    func editDocumentName(document: DocumentModel, name: String)
    func editDocumentPage(url: String, page: Int)
    func deleteDocument(document: DocumentModel)
    func getDocuments()->[DocumentModel]
    func saveImage(image: ImageModel)
    func deleteImage(image: ImageModel)
    func getImages()->[ImageModel]
    func saveArticle(model: NewsModel)
    func getArticle(id: Int)-> NewsModel?
    func editArticle(news: NewsModel, position: Double)
    func saveSplashScreen(screen: CustomSplashScreenModel)
    func getSplashScreen()-> CustomSplashScreenModel
    func saveTimetableItem(item: SearchTimetableModel)
    func deleteTimetableItem(item: SearchTimetableModel)
    func getTimetableItems()-> [SearchTimetableModel]
}
