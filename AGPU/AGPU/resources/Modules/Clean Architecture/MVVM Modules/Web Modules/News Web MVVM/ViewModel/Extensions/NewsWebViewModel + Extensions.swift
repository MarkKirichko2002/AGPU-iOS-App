//
//  NewsWebViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import Foundation

// MARK: - INewsWebViewModel
extension NewsWebViewModel: INewsWebViewModel {
    
    func saveArticlePosition(position: Double) {
        if let article = realmManager.getArticle(id: article.id) {
            realmManager.editArticle(news: article, position: position)
        } else {
            let model = NewsModel()
            model.id = article.id
            model.offsetY = 0
            realmManager.saveArticle(news: article, model: model)
        }
    }
    
    func getPosition() {
        if let news = realmManager.getArticle(id: article.id) {
            scrollPositionHandler?(news.offsetY)
        } else {
            scrollPositionHandler?(0)
            print("нет такой новости")
        }
    }
    
    func registerScrollPositionHandler(block: @escaping(Double)->Void) {
        self.scrollPositionHandler = block
    }
}
