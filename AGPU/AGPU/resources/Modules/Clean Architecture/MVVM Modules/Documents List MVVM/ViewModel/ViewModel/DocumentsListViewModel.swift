//
//  DocumentsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.08.2023.
//

import Foundation

class DocumentsListViewModel {
    
    var documents = [DocumentModel]()
    var docs = [DocumentModel]()
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let service = HTMLParser()
    
    var url: String = ""
    
    // MARK: - Init
    init(url: String) {
        self.url = url
    }
}
