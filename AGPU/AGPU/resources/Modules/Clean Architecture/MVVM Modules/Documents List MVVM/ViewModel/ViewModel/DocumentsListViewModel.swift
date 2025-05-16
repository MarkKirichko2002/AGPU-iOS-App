//
//  DocumentsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import Foundation

final class DocumentsListViewModel {
    
    var formats = ["pdf", "doc", "docx", "txt"]
    var documents = [DocumentModel]()
    
    var invalidFormatAlertHandler: (()-> Void)?
    var invalidURLAlertHandler: (()-> Void)?
    var dataChangedHandler:(()-> Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let settingsManager = SettingsManager()
    let speechSynthesizerManager = SpeechSynthesizerManager()
    
}
