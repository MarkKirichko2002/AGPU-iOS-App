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
            if category.newsAbbreviation != "" {
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
        if category.newsAbbreviation != currentCategory {
            if let faculty = AGPUFaculties.faculties.first(where: { $0.newsAbbreviation ==  category.newsAbbreviation}) {
                NotificationCenter.default.post(name: Notification.Name("category"), object: faculty.newsAbbreviation)
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                UserDefaults.standard.setValue(faculty.newsAbbreviation, forKey: "category")
                self.currentCategory = category.newsAbbreviation
                HapticsManager.shared.hapticFeedback()
            } else {
                NotificationCenter.default.post(name: Notification.Name("category"), object: "")
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                UserDefaults.standard.setValue("", forKey: "category")
                self.currentCategory = category.newsAbbreviation
                HapticsManager.shared.hapticFeedback()
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
