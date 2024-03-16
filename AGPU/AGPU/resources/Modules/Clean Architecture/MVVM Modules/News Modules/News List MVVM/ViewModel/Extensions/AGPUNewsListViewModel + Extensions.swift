//
//  AGPUNewsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

// MARK: - AGPUNewsListViewModelProtocol
extension AGPUNewsListViewModel: AGPUNewsListViewModelProtocol {
    
    // вернуть элемент новости
    func articleItem(index: Int)-> Article {
        if let article = newsResponse.articles?[index] {
            return article
        }
        return Article(id: 0, title: "", description: "", date: "", previewImage: "")
    }
    
    // получить новости в зависимости от типа
    func getNewsByCurrentType() {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? "-"
        if savedNewsCategory != "-" {
            getNews(abbreviation: savedNewsCategory)
        } else {
            getAGPUNews()
            abbreviation = "-"
        }
    }
    
    // получить новости АГПУ
    func getAGPUNews() {
        Task {
            let result = try await newsService.getAGPUNews()
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.dataChangedHandler?("-")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новости
    func getNews(abbreviation: String) {
        Task {
            let result = try await newsService.getNews(abbreviation: abbreviation)
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.dataChangedHandler?(abbreviation)
                self.abbreviation = abbreviation
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новость по странице
    func getNews(by page: Int) {
        Task {
            let result = try await newsService.getNews(by: page, abbreviation: abbreviation)
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.dataChangedHandler?(self.abbreviation)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getRandomNews() {
        let abbreviation = NewsCategories.categories.randomElement()!.newsAbbreviation
        if abbreviation != "-" {
            getNews(abbreviation: abbreviation)
        } else {
            getAGPUNews()
        }
    }
    
    func refreshNews() {
        if let page = newsResponse.currentPage {
            getNews(by: page)
            NotificationCenter.default.post(name: Notification.Name("refreshed"), object: nil)
        }
    }
    
    // следить за изменением категории
    func observeCategoryChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("category"), object: nil, queue: .main) { notification in
            guard let category = notification.object as? String else {return}
            print("категория: \(category)")
            if category != self.abbreviation {
                if category != "-" {
                    self.getNews(abbreviation: category)
                    self.abbreviation = category
                    UserDefaults.standard.setValue(category, forKey: "category")
                } else {
                    self.getAGPUNews()
                    self.abbreviation = "-"
                    UserDefaults.standard.setValue("-", forKey: "category")
                }
            }
        }
    }
    
    // следить за изменением страницы
    func observePageChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("page"), object: nil, queue: .main) { notification in
            if let page = notification.object as? Int {
                self.getNews(by: page)
            }
        }
    }
    
    // получить URL для конкретной статьи
    func makeUrlForCurrentArticle(index: Int)-> String {
        let url = newsService.urlForCurrentArticle(abbreviation: abbreviation, index: articleItem(index: index).id)
        return url
    }
    
    // получить URL для конкретной веб-страницы
    func makeUrlForCurrentWebPage()-> String {
        let url = newsService.urlForCurrentWebPage(abbreviation: abbreviation, currentPage: newsResponse.currentPage ?? 0)
        return url
    }
    
    func sendNotificationArticleWasSelected() {
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("article selected"), object: nil)
        }
    }
    
    func registerCategoryChangedHandler(block: @escaping(String)->Void) {
        self.dataChangedHandler = block
    }
}
