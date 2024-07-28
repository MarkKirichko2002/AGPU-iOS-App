//
//  DocumentsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import Foundation

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
    
    func addDocument(document: DocumentModel) {
        if isDocument(document: document) {
            realmManager.saveDocument(document: document)
            getDocuments()
        } else {
            alertHandler?()
        }
    }
    
    func editDocument(document: DocumentModel, name: String) {
        realmManager.editDocumentName(document: document, name: name)
        getDocuments()
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
        if formats.contains(document.format.lowercased()) {
            return true
        }
        return false
    }
    
    func registerAlertHandler(block: @escaping()->Void) {
        self.alertHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()-> Void) {
        self.dataChangedHandler = block
    }
}
