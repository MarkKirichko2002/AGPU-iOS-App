//
//  DocumentsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 19.02.2024.
//

import Foundation

class DocumentsListViewModel {
    
    var dataChangedHandler:(()-> Void)?
    var documents = [DocumentModel]()
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    
}
