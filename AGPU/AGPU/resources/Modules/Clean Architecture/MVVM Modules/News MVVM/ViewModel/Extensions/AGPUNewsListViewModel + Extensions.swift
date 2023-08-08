//
//  AGPUNewsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

// MARK: - AGPUNewsListViewModelProtocol
extension AGPUNewsListViewModel: AGPUNewsListViewModelProtocol {
    
    func GetNews() {
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            self.faculty = faculty
            newsService.GetFacultyNews(abbreviation: faculty.newsAbbreviation) { result in
                switch result {
                case .success(let news):
                    self.news = news
                    self.dataChangedHandler?(faculty)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func articleItem(index: Int)-> NewsModel {
        let article = news[index]
        return article
    }
    
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel)->Void) {
        self.dataChangedHandler = block
    }
    
    func ObserveFacultyChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("faculty"), object: nil, queue: .main) { _ in
            self.GetNews()
        }
    }
    
    func urlForCurrentArticle(index: Int)-> String {
        let newsURL = "http://test.agpu.net/struktura-vuza/faculties-institutes/\(faculty?.newsAbbreviation ?? "")/news/news.php?ELEMENT_ID=\(articleItem(index: index).id)"
        print(newsURL)
        return newsURL
    }
}
