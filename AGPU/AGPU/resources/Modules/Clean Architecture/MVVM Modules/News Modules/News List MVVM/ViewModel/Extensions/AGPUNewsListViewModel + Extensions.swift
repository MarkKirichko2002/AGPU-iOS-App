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
    
    func checkSettings() {
        registerDataIsLoadedHandler {
            self.option = UserDefaults.loadData(type: NewsOptionsFilters.self, key: "news filter") ?? .all
            self.filterNews(option: self.option)
        }
        getNewsByCurrentType()
    }
    
    // получить новости в зависимости от типа
    func getNewsByCurrentType() {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? "-"
        if savedNewsCategory != "-" {
            getFilteredNews(abbreviation: savedNewsCategory)
        } else {
            getFilteredAGPUNews()
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
                switch displayMode {
                case .grid:
                    allNews = response.articles ?? []
                    option = .all
                    dataChangedHandler?("-")
                case .webpage:
                    dataChangedHandler?("-")
                    webModeHandler?()
                }
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
                self.abbreviation = abbreviation
                switch displayMode {
                case .grid:
                    allNews = response.articles ?? []
                    option = .all
                    dataChangedHandler?(abbreviation)
                case .webpage:
                    dataChangedHandler?(abbreviation)
                    webModeHandler?()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFilteredAGPUNews() {
        Task {
            let result = try await newsService.getAGPUNews()
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.allNews = response.articles ?? []
                self.option = .all
                self.dataChangedHandler?("-")
                self.dataIsLoadedHandler?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новости
    func getFilteredNews(abbreviation: String) {
        Task {
            let result = try await newsService.getNews(abbreviation: abbreviation)
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.allNews = response.articles ?? []
                self.option = .all
                self.abbreviation = abbreviation
                self.dataChangedHandler?(abbreviation)
                self.dataIsLoadedHandler?()
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
                switch displayMode {
                case .grid:
                    self.allNews = response.articles ?? []
                    self.option = .all
                    self.dataChangedHandler?(self.abbreviation)
                case .webpage:
                    self.webModeHandler?()
                }
            case .failure(let error):
                print(error)
            }
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
            if category != self.abbreviation {
                if category != "-" {
                    self.getNews(abbreviation: category)
                    self.option = .all
                    self.abbreviation = category
                    UserDefaults.standard.setValue(category, forKey: "category")
                } else {
                    self.getAGPUNews()
                    self.option = .all
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
    
    func observeDisplayMode() {
        NotificationCenter.default.addObserver(forName: Notification.Name("display mode option"), object: nil, queue: .main) { notification in
            if let displayMode = notification.object as? DisplayModes {
                self.displayMode = displayMode
                self.dislayModeHandler?(displayMode)
            }
        }
    }
    
    func observeFilterOption() {
        NotificationCenter.default.addObserver(forName: Notification.Name("news filter option"), object: nil, queue: .main) { notification in
            if let option = notification.object as? NewsOptionsFilters {
                self.option = option
                self.filterNews(option: option)
            }
        }
    }
    
    func observeStrokeOption() {
        NotificationCenter.default.addObserver(forName: Notification.Name("daily news border option"), object: nil, queue: .main) { _ in
            self.dataChangedHandler?(self.abbreviation)
        }
    }
    
    func filterNews(option: NewsOptionsFilters) {
        switch option {
        case .today:
            let date = dateManager.getCurrentDate()
            let filteredNews = allNews.filter({ $0.date == date})
            newsResponse.articles = filteredNews
            dataChangedHandler?(abbreviation)
        case .yesterday:
            let date = dateManager.getCurrentDate()
            let yesterday = dateManager.previousDay(date: date)
            let filteredNews = allNews.filter({ $0.date == yesterday})
            newsResponse.articles = filteredNews
            dataChangedHandler?(abbreviation)
        case .dayBeforeYesterday:
            let date = dateManager.getCurrentDate()
            let yesterday = dateManager.previousDay(date: date)
            let beforeYesterday = dateManager.previousDay(date: yesterday)
            let filteredNews = allNews.filter({ $0.date == beforeYesterday})
            newsResponse.articles = filteredNews
            dataChangedHandler?(abbreviation)
        case .all:
            newsResponse.articles = allNews
            dataChangedHandler?(abbreviation)
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
    
    private func registerDataIsLoadedHandler(block: @escaping()->Void) {
        self.dataIsLoadedHandler = block
    }
    
    func registerDislayModeHandler(block: @escaping(DisplayModes)->Void) {
        self.dislayModeHandler = block
    }
    
    func registerWebModeHandler(block: @escaping()->Void) {
        self.webModeHandler = block
    }
}
