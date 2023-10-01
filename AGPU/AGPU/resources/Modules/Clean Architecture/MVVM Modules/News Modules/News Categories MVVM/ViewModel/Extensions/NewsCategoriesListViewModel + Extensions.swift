//
//  NewsCategoriesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2023.
//

import Foundation

// MARK: - NewsCategoriesListViewModelProtocol
extension NewsCategoriesListViewModel: NewsCategoriesListViewModelProtocol {
    
    func registerCategorySelectedHandler(block: @escaping((String)->Void)) {
        self.categorySelectedHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func categoryItem(index: Int)-> NewsCategoryModel {
        let category = NewsCategories.categories[index]
        return category
    }
    
    func numberOfCategoriesInSection()-> Int {
        return NewsCategories.categories.count
    }
    
    func getNewsCategoriesInfo() {
        for category in NewsCategories.categories {
            if category.name != "АГПУ" {
                newsService.getFacultyNews(abbreviation: category.newsAbbreviation) { result in
                    switch result {
                    case .success(let data):
                        NewsCategories.categories[category.id].pagesCount = data.countPages ?? 0
                        self.dataChangedHandler?()
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                newsService.getAGPUNews { result in
                    switch result {
                    case .success(let data):
                        NewsCategories.categories[0].pagesCount = data.countPages ?? 0
                        self.dataChangedHandler?()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
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
        } else {
            self.categorySelectedHandler?("Категория \(category.name) уже выбрана")
        }
    }
    
    func isCurrentCategory(index: Int)-> Bool {
        let category = categoryItem(index: index)
        if category.name == currentCategory {
            return true
        } else {
            return false
        }
    }
}
