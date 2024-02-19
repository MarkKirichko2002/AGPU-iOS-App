//
//  IRealmManager.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import Foundation

protocol IRealmManager {
    func saveDocument(document: DocumentModel)
    func editDocument(document: DocumentModel, name: String)
    func deleteDocument(document: DocumentModel)
    func getDocuments()->[DocumentModel]
}
