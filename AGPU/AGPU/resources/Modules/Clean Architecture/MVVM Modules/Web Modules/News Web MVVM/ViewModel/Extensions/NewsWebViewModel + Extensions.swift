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
            model.title = article.title
            model.articleDescription = article.description
            model.url = url
            model.offsetY = 0
            model.previewImage = article.previewImage
            model.date = article.date
            realmManager.saveArticle(model: model)
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
    
    func saveCurrentWebArticle(url: String, position: CGPoint) {
        let dateManager = DateManager()
        let date = dateManager.getCurrentDate()
        let time = dateManager.getCurrentTime()
        let article = RecentWebPageModel(date: date, time: time, url: url, position: position)
        UserDefaults.saveData(object: article, key: "last article") {
            print("сохранено: \(article)")
        }
    }
    
    func getCategoryIcon(url: String)-> String {
        let items = url.components(separatedBy: "/")
        for item in items {
            if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == item }) {
                return newsCategory.icon
            }
        }
        return "АГПУ"
    }
    
    func registerScrollPositionHandler(block: @escaping(Double)->Void) {
        self.scrollPositionHandler = block
    }
}
