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
    
    func registerDataChangedHandler(block: @escaping() -> Void) {
        self.dataChangedHandler = block
    }
}
