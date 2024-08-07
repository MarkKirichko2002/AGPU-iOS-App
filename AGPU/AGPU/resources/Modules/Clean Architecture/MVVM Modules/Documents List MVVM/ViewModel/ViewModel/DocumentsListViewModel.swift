//
//  DocumentsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import Foundation

final class DocumentsListViewModel {
    
    var alertHandler: (()-> Void)?
    var dataChangedHandler:(()-> Void)?
    var formats = ["pdf", "doc", "docx"]
    var documents = [DocumentModel]()
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let speechSynthesizerManager = SpeechSynthesizerManager()
    
}
