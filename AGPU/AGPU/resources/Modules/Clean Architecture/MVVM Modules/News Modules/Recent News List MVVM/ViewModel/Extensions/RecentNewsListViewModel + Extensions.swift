//
//  RecentNewsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.03.2024.
//

import Foundation

// MARK: - IRecentNewsListViewModel
extension RecentNewsListViewModel: IRecentNewsListViewModel {
    
    func articleItem(index: Int)-> Article {
        let item = news[index]
        let article = Article(id: item.id, title: item.title, description: item.articleDescription, date: item.date, previewImage: item.previewImage)
        return article
    }
    
    func getNews() {
        news = realmManager.getArticles()
        dataChangedHandler?()
    }
    
    func resetProgress(id: Int) {
        realmManager.editArticle(news: news[id], position: 0)
    }
    
    func deleteArticle(id: Int) {
        let article = news[id]
        realmManager.deleteArticle(news: article)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            self.getNews()
        }
    }
     
    func makeUrlForCurrentArticle(index: Int)-> String {
        let item = news[index]
        return item.url
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
