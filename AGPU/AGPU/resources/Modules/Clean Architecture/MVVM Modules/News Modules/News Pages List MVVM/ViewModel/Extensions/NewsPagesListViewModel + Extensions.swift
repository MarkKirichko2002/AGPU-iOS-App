//
//  NewsPagesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 20.08.2023.
//

import Foundation

// MARK: - NewsPagesListViewModelProtocol
extension NewsPagesListViewModel: NewsPagesListViewModelProtocol {
    
    func currentNewsCategoryIcon()-> String {
        let category = NewsCategories.categories.first { $0.newsAbbreviation == abbreviation }
        return category?.icon ?? ""
    }
    
    func pageNumberItem(index: Int)-> Int {
        return pages[index].pageNumber
    }
    
    func pageItem(index: Int)-> String {
        let page = pages[index]
        return "Страница \(page.pageNumber)"
    }
    
    func numberOfPagesInSection()-> Int {
        return pages.count
    }
    
    func setUpData() {
        for i in 1...countPages {
            pages.append(NewsPageModel(pageNumber: i, newsCount: 0))
        }
        self.dataChangedHandler?()
    }
    
    func getNewsPagesInfo() {
        
        let dispatchGroup = DispatchGroup()
        
        for page in 1...pages.count {
            isStartLoading = true
            dispatchGroup.enter()
            Task {
                let result = try await newsService.getNews(by: page, abbreviation: abbreviation ?? "-")
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let data):
                    self.pages[page - 1].newsCount = data.articles?.count ?? 0
                case .failure(let error):
                    print(error)
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
    
    func titleForNavigation()-> String {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return "Выберите страницу"
        case .informal:
            return "Выбери страницу"
        }
    }
    
    func registerPageSelectedHandler(block: @escaping((String)->Void)) {
        self.pageSelectedHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
