//
//  NewsPagesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 20.08.2023.
//

import Foundation

// MARK: - NewsPagesListViewModelProtocol
extension NewsPagesListViewModel: NewsPagesListViewModelProtocol {
    
    func pageItem(index: Int)-> String {
        let page = pages[index]
        var pageItem = ""
        if isStartLoading {
            pageItem = "страница \(page.pageNumber) (загрузка...)"
        } else {
            pageItem = "страница \(page.pageNumber) (новостей: \(pages[index].newsCount))"
        }
        return pageItem
    }
    
    func numberOfPagesInSection()-> Int {
        return pages.count
    }
    
    func setUpData() {
        
        let countPages = self.countPages

        for i in 1...countPages {
            pages.append(NewsPageModel(pageNumber: i, newsCount: 0))
        }
        getNewsPagesInfo()
    }
    
    func getNewsPagesInfo() {
        
        let dispatchGroup = DispatchGroup()
        
        for page in 0..<pages.count {
            isStartLoading = true
            dispatchGroup.enter()
            if abbreviation != "" {
                newsService.getNews(by: page, abbreviation: abbreviation ?? "") { [weak self] result in
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let data):
                        self?.pages[page].newsCount = data.articles?.count ?? 0
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                newsService.getNews(by: page, abbreviation: "") { [weak self] result in
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let data):
                        self?.pages[page].newsCount = data.articles?.count ?? 0
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.isStartLoading = false
            self.dataChangedHandler?()
        }
    }
    
    func chooseNewsPage(index: Int) {
        let page = pages[index]
        if currentPage != page.pageNumber {
            NotificationCenter.default.post(name: Notification.Name("page"), object: page.pageNumber)
            currentPage = page.pageNumber
            self.dataChangedHandler?()
            self.pageSelectedHandler?("Выбрана страница \(page.pageNumber)")
            HapticsManager.shared.hapticFeedback()
        } else {}
    }
    
    func isCurrentPage(index: Int)-> Bool {
        let page = pages[index]
        if page.pageNumber == currentPage {
            return true
        } else {
            return false
        }
    }
    
    func registerPageSelectedHandler(block: @escaping((String)->Void)) {
        self.pageSelectedHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
