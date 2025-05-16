//
//  DocumentsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import UIKit

// MARK: - IDocumentsListViewModel
extension DocumentsListViewModel: IDocumentsListViewModel {
    
    func documentsCount()-> Int {
        return documents.count
    }
    
    func documentItem(index: Int) -> DocumentModel {
        return documents[index]
    }
    
    func getDocuments() {
        documents = realmManager.getDocuments()
        dataChangedHandler?()
    }
    
    func getChanges(index: Int) {
        documents = realmManager.getDocuments()
        itemChangedHandler?(index)
    }
    
    func addDocument(by url: URL) {
        let document = createDocument(url: url)
        if isValidURL(url: document.url) {
            if isDocument(document: document) {
                realmManager.saveDocument(document: document)
                getDocuments()
            }
        } else {
            invalidURLAlertHandler?()
        }
    }
    
    func addDocumentFromFiles(url: URL) {
        let document = createDocument(url: url)
        if isDocument(document: document) {
            realmManager.saveDocument(document: document)
            getDocuments()
        } else {
            invalidFormatAlertHandler?()
        }
    }
    
    func createDocument(url: URL)-> DocumentModel {
        let document = DocumentModel()
        document.url = url.absoluteString
        document.name = url.lastPathComponent
        document.format = url.pathExtension
        document.page = 0
        return document
    }
    
    func editDocument(document: DocumentModel, name: String) {
        let index = documents.firstIndex(where: { $0.url == document.url })!
        if documents[index].name != name {
            realmManager.editDocumentName(document: document, name: name)
            getChanges(index: index)
        }
    }
    
    func updateDocuments(documents: [DocumentModel], _ index: Int, _ index2: Int) {
        realmManager.updateDocuments(documents: documents, index, index2)
        getDocuments()
    }
    
    func deleteDocument(document: DocumentModel) {
        realmManager.deleteDocument(document: document)
        getDocuments()
    }
    
    func isDocument(document: DocumentModel)-> Bool {
        return formats.contains(document.format)
    }
    
    func isValidURL(url: String)-> Bool {
        return UIApplication.shared.isValidURL(url: url)
    }
    
    func createTextForEditAlert()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Добавить документ", "\(!name.isEmpty ? "\(name) введите" : "Введите") URL для документа")
        case .informal:
            return ("Добавить документ", "\(!name.isEmpty ? "\(name) введи" : "Введи") URL для документа")
        }
    }
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Данные не введены!", "\(!name.isEmpty ? "\(name) введите" : "Введите") данные для документа")
        case .informal:
            return ("Данные не введены!", "\(!name.isEmpty ? "\(name) введи" : "Введи") данные в текстовом поле")
        }
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить документ", "\(!name.isEmpty ? "\(name) вы точно хотите изменить" : "Вы точно хотите изменить") название документа?")
        case .informal:
            return ("Изменить документ", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") название документа?")
        }
    }
    
    func registerInvalidFormatAlertHandler(block: @escaping()->Void) {
        self.invalidFormatAlertHandler = block
    }
    
    func registerInvalidURLAlertHandler(block: @escaping()->Void) {
        self.invalidURLAlertHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()-> Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)-> Void) {
        self.itemChangedHandler = block
    }
}
