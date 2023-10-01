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
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            if !faculty.newsAbbreviation.isEmpty {
                getFacultyNews(faculty: faculty)
            } else {
                getAGPUNews()
                self.faculty = nil
            }
        } else {
            getAGPUNews()
            self.faculty = nil
        }
    }
    
    // получить новости АГПУ
    func getAGPUNews() {
        newsService.getAGPUNews { [weak self] result in
            switch result {
            case .success(let response):
                self?.newsResponse = response
                self?.dataChangedHandler?(nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новости факультета
    func getFacultyNews(faculty: AGPUFacultyModel) {
        self.faculty = faculty
        newsService.getFacultyNews(abbreviation: faculty.newsAbbreviation) { [weak self] result in
            switch result {
            case .success(let response):
                self?.newsResponse = response
                self?.dataChangedHandler?(faculty)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новость по странице
    func getNews(by page: Int) {
        newsService.getNews(by: page, faculty: faculty) { [weak self] result in
            switch result {
            case .success(let response):
                self?.newsResponse = response
                self?.dataChangedHandler?(self?.faculty)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshNews() {
        if let page = newsResponse.currentPage {
            getNews(by: page)
            NotificationCenter.default.post(name: Notification.Name("news refreshed"), object: nil)
        }
    }
    
    // вернуть элемент новости
    func articleItem(index: Int)-> Article {
        if let article = newsResponse.articles?[index] {
            return article
        }
        return Article(id: 0, title: "", description: "", date: "", previewImage: "")
    }
    
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel?)->Void) {
        self.dataChangedHandler = block
    }
    
    // следить за изменением факультета
    func observeFacultyChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("faculty"), object: nil, queue: .main) { notification in
            if let faculty = notification.object as? AGPUFacultyModel {
                self.getFacultyNews(faculty: faculty)
            } else {
                self.getAGPUNews()
                self.faculty = nil
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
        let url = newsService.urlForCurrentArticle(faculty: self.faculty, index: articleItem(index: index).id)
        return url
    }
}
