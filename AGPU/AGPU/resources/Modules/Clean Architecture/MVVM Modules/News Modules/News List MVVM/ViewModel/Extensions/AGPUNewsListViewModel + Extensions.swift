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
    func GetNewsByCurrentType() {
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            if !faculty.newsAbbreviation.isEmpty {
                GetFacultyNews(faculty: faculty)
            } else {
                GetAGPUNews()
                self.faculty = nil
            }
        } else {
            GetAGPUNews()
            self.faculty = nil
        }
    }
    
    // получить новости АГПУ
    func GetAGPUNews() {
        newsService.GetAGPUNews { result in
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.dataChangedHandler?(nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новости факультета
    func GetFacultyNews(faculty: AGPUFacultyModel) {
        self.faculty = faculty
        newsService.GetFacultyNews(abbreviation: faculty.newsAbbreviation) { result in
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.dataChangedHandler?(faculty)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // получить новость по странице
    func GetNews(by page: Int) {
        newsService.GetNews(by: page, faculty: faculty) { result in
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.dataChangedHandler?(self.faculty)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func RefreshNews() {
        if let page = newsResponse.currentPage {
            GetNews(by: page)
            HapticsManager.shared.HapticFeedback()
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
    func ObserveFacultyChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("faculty"), object: nil, queue: .main) { notification in
            if let faculty = notification.object as? AGPUFacultyModel {
                self.GetFacultyNews(faculty: faculty)
            } else {
                self.GetAGPUNews()
                self.faculty = nil
            }
        }
    }
    
    // следить за изменением страницы
    func ObservePageChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("page"), object: nil, queue: .main) { notification in
            if let page = notification.object as? Int {
                self.GetNews(by: page)
            }
        }
    }
    
    // получить URL для конкретной статьи
    func makeUrlForCurrentArticle(index: Int)-> String {
        let url = newsService.urlForCurrentArticle(faculty: self.faculty, index: articleItem(index: index).id)
        return url
    }
}
