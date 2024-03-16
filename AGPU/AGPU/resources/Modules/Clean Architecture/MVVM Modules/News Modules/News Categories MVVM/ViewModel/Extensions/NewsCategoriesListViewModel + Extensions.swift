//
//  NewsCategoriesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2023.
//

import Foundation

// MARK: - NewsCategoriesListViewModelProtocol
extension NewsCategoriesListViewModel: NewsCategoriesListViewModelProtocol {
    
    func categoryItem(index: Int)-> NewsCategoryModel {
        let category = NewsCategories.categories[index]
        return category
    }
    
    func numberOfCategoriesInSection()-> Int {
        return NewsCategories.categories.count
    }
    
    func getNewsCategoriesInfo() {
        
        let dispatchGroup = DispatchGroup()
        
        for category in NewsCategories.categories {
            dispatchGroup.enter()
            if category.newsAbbreviation != "-" {
                Task {
                    let result = try await newsService.getNews(abbreviation: category.newsAbbreviation)
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let data):
                        NewsCategories.categories[category.id].pagesCount = data.countPages ?? 0
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                Task {
                    let result = try await newsService.getAGPUNews()
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let data):
                        NewsCategories.categories[0].pagesCount = data.countPages ?? 0
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
    
    func chooseNewsCategory(index: Int) {
        let category = categoryItem(index: index)
        if category.newsAbbreviation != currentCategory {
            if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation ==  category.newsAbbreviation}) {
                if newsCategory.newsAbbreviation != "-" {
                    NotificationCenter.default.post(name: Notification.Name("category"), object: newsCategory.newsAbbreviation)
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                    self.currentCategory = category.newsAbbreviation
                    HapticsManager.shared.hapticFeedback()
                    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                        NotificationCenter.default.post(name: Notification.Name("icon"), object: category.icon)
                    }
                } else {
                    NotificationCenter.default.post(name: Notification.Name("category"), object: "-")
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                    self.currentCategory = category.newsAbbreviation
                    HapticsManager.shared.hapticFeedback()
                    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                        NotificationCenter.default.post(name: Notification.Name("icon"), object: "АГПУ")
                    }
                }
            }
            print(category.newsAbbreviation)
            self.categorySelectedHandler?("Выбрана категория \(category.name)")
        } else {}
    }
    
    func isCurrentCategory(index: Int)-> Bool {
        let category = categoryItem(index: index)
        if category.newsAbbreviation == currentCategory {
            return true
        } else {
            return false
        }
    }
    
    func registerCategorySelectedHandler(block: @escaping((String)->Void)) {
        self.categorySelectedHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
