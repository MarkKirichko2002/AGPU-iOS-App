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
            if category.name != "АГПУ" {
                newsService.getFacultyNews(abbreviation: category.newsAbbreviation) { [weak self] result in
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let data):
                        NewsCategories.categories[category.id].pagesCount = data.countPages ?? 0
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                newsService.getAGPUNews { [weak self] result in
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
        if category.name != currentCategory {
            if let faculty = AGPUFaculties.faculties.first(where: { $0.abbreviation ==  category.name}) {
                NotificationCenter.default.post(name: Notification.Name("faculty"), object: faculty)
                self.currentCategory = category.name
                HapticsManager.shared.hapticFeedback()
            } else {
                NotificationCenter.default.post(name: Notification.Name("faculty"), object: nil)
                self.currentCategory = category.name
                HapticsManager.shared.hapticFeedback()
            }
            self.categorySelectedHandler?("Выбрана категория \(category.name)")
        } else {}
    }
    
    func isCurrentCategory(index: Int)-> Bool {
        let category = categoryItem(index: index)
        if category.name == currentCategory {
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
