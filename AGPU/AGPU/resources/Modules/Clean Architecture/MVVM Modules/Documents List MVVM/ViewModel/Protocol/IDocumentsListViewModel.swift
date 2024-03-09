//
//  IDocumentsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import Foundation

protocol IDocumentsListViewModel {
    func documentsCount()-> Int
    func documentItem(index: Int)-> DocumentModel
    func getDocuments()
    func editDocument(document: DocumentModel, name: String)
    func deleteDocument(document: DocumentModel)
    func registerDataChangedHandler(block: @escaping()->Void)
}
