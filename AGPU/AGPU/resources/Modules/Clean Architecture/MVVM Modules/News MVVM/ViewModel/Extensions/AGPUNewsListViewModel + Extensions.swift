//
//  AGPUNewsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import UIKit

// MARK: - AGPUNewsListViewModelProtocol
extension AGPUNewsListViewModel: AGPUNewsListViewModelProtocol {
    
    func GetNews() {
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
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
        } else {
            newsService.GetAGPUNews { result in
                switch result {
                case .success(let response):
                    self.newsResponse = response
                    print(self.newsResponse)
                    self.dataChangedHandler?(self.faculty)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func articleItem(index: Int)-> Article {
        let article = newsResponse.articles[index]
        return article
    }
    
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel?)->Void) {
        self.dataChangedHandler = block
    }
    
    func ObserveFacultyChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("faculty"), object: nil, queue: .main) { _ in
            self.GetNews()
        }
    }
    
    func urlForCurrentArticle(index: Int)-> String {
        var newsURL = ""
        if faculty != nil {
            newsURL = "http://test.agpu.net/struktura-vuza/faculties-institutes/\(faculty?.newsAbbreviation ?? "")/news/news.php?ELEMENT_ID=\(articleItem(index: index).id)"
        } else {
            newsURL = "http://test.agpu.net/news.php?ELEMENT_ID=\(articleItem(index: index).id)"
        }
        return newsURL
    }
    
    func pagesMenu()-> UIMenu {
        var arr = [UIAction]()
        for i in 1...self.newsResponse.countPages {
            let page = UIAction(title: "страница \(i)") { _ in}
            arr.append(page)
        }
        let menu = UIMenu(title: "страницы", options: .singleSelection, children: arr)
        return menu
    }
}
