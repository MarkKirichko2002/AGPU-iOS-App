//
//  AGPUNewsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

// MARK: - AGPUNewsListViewModelProtocol
extension AGPUNewsListViewModel: AGPUNewsListViewModelProtocol {
    
    // получить новости в зависимости от типа
    func getNewsByCurrentType() {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? ""
        if savedNewsCategory != "" {
            getFacultyNews(abbreviation: savedNewsCategory)
        } else {
            getAGPUNews()
            abbreviation = ""
        }
    }
    
    // получить новости АГПУ
    func getAGPUNews() {
        newsService.getAGPUNews { [weak self] result in
            switch result {
            case .success(let response):
                self?.newsResponse = response
                self?.dataChangedHandler?("")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новости факультета
    func getFacultyNews(abbreviation: String) {
        newsService.getFacultyNews(abbreviation: abbreviation) { [weak self] result in
            switch result {
            case .success(let response):
                self?.newsResponse = response
                self?.dataChangedHandler?(abbreviation)
                self?.abbreviation = abbreviation
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новость по странице
    func getNews(by page: Int) {
        newsService.getNews(by: page, abbreviation: abbreviation) { [weak self] result in
            switch result {
            case .success(let response):
                self?.newsResponse = response
                self?.dataChangedHandler?(self?.abbreviation ?? "")
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
    
    // вернуть элемент новости
    func articleItem(index: Int)-> Article {
        if let article = newsResponse.articles?[index] {
            return article
        }
        return Article(id: 0, title: "", description: "", date: "", previewImage: "")
    }
    
    func registerCategoryChangedHandler(block: @escaping(String)->Void) {
        self.dataChangedHandler = block
    }
    
    // следить за изменением категории
    func observeCategoryChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("category"), object: nil, queue: .main) { notification in
            if let category = notification.object as? String {
                print("category: \(category)")
                if category != "" {
                    self.getFacultyNews(abbreviation: category)
                    self.abbreviation = category
                } else {
                    self.getAGPUNews()
                    self.abbreviation = ""
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
}
