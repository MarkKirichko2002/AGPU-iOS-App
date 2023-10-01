//
//  NewsPagesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 20.08.2023.
//

import Foundation

// MARK: - NewsPagesListViewModelProtocol
extension NewsPagesListViewModel: NewsPagesListViewModelProtocol {
    
    func setUpData() {
        
        let countPages = self.countPages
        let dispatchGroup = DispatchGroup()

        for i in 1...countPages {
            pages.append(NewsPageModel(pageNumber: i, newsCount: 0))
        }

        for page in 0..<pages.count {
            dispatchGroup.enter()
            if let faculty = faculty {
                newsService.getNews(by: page, faculty: faculty) { [weak self] result in
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let data):
                        self?.pages[page].newsCount = data.articles?.count ?? 0
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                newsService.getNews(by: page, faculty: nil) { [weak self] result in
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
            self.dataChangedHandler?()
        }
    }
    
    func registerPageSelectedHandler(block: @escaping((String)->Void)) {
        self.pageSelectedHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func pageItem(index: Int)-> String {
        let page = "страница \(pages[index].pageNumber) (новостей: \(pages[index].newsCount))"
        return page
    }
    
    func numberOfPagesInSection()-> Int {
        return pages.count
    }
    
    func chooseNewsPage(index: Int) {
        let page = pages[index]
        if currentPage != page.pageNumber {
            NotificationCenter.default.post(name: Notification.Name("page"), object: page)
            currentPage = page.pageNumber
            self.dataChangedHandler?()
            self.pageSelectedHandler?("Выбрана страница \(page.pageNumber)")
            HapticsManager.shared.hapticFeedback()
        } else {
            self.pageSelectedHandler?("Страница \(page) уже выбрана")
        }
    }
    
    func isCurrentPage(index: Int)-> Bool {
        let page = pages[index]
        if page.pageNumber == currentPage {
            return true
        } else {
            return false
        }
    }
}
