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
    
    func GetNews(by page: Int, faculty: AGPUFacultyModel?) {
        var url = ""
        if faculty != nil {
            url = newsService.urlForPagination(faculty: faculty, page: page)
        } else {
            url = newsService.urlForPagination(faculty: nil, page: page)
        }
        newsService.GetNews(by: page, faculty: faculty) { result in
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.dataChangedHandler?(faculty)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // вернуть элемент новости
    func articleItem(index: Int)-> Article {
        let article = newsResponse.articles[index]
        return article
    }
    
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel?)->Void) {
        self.dataChangedHandler = block
    }
    
    func ObserveFacultyChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("faculty"), object: nil, queue: .main) { notification in
            if let faculty = notification.object as? AGPUFacultyModel {
                self.GetFacultyNews(faculty: faculty)
            } else {
                self.GetAGPUNews()
                self.faculty = nil
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("page"), object: nil, queue: .main) { notification in
            if let page = notification.object as? Int {
                self.GetNews(by: page, faculty: self.faculty)
            }
        }
    }
    
    func makeUrlForCurrentArticle(index: Int)-> String {
        let url = newsService.urlForCurrentArticle(faculty: self.faculty, index: articleItem(index: index).id)
        return url
    }
}