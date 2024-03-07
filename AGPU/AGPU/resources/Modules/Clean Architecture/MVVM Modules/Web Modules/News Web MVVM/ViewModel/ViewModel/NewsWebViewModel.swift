//
//  NewsWebViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import Foundation

class NewsWebViewModel {
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    
    var scrollPositionHandler: ((Double)->Void)?
    var article: Article
    var url: String = ""
    
    // MARK: - Init
    init(article: Article, url: String) {
        self.article = article
        self.url = url
    }
}
