//
//  NewsWebViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import Foundation

final class NewsWebViewModel {
    
    var scrollPositionHandler: ((Double)->Void)?
    var article: Article
    var url: String = ""
    
    var currentScrollPosition: scrollPositions?
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let dateManager = DateManager()
    
    // MARK: - Init
    init(article: Article, url: String) {
        self.article = article
        self.url = url
    }
}
