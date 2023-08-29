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
    
    func numberOfCategoriesInSection()->Int {
        return NewsCategories.categories.count
    }
    
    func chooseNewsCategory(index: Int) {
        let category = categoryItem(index: index)
        if category.name != currentCategory {
            if let faculty = AGPUFaculties.faculties.first(where: { $0.abbreviation ==  category.name}) {
                NotificationCenter.default.post(name: Notification.Name("faculty"), object: faculty)
                self.currentCategory = category.name
                self.dataChangedHandler?()
                HapticsManager.shared.HapticFeedback()
            } else {
                NotificationCenter.default.post(name: Notification.Name("faculty"), object: nil)
                self.currentCategory = category.name
                self.dataChangedHandler?()
                HapticsManager.shared.HapticFeedback()
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
