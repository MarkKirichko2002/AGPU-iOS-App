//
//  SavedNewsCategoryViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.11.2023.
//

import Foundation

// MARK: - SavedNewsCategoryViewModelProtocol
extension SavedNewsCategoryViewModel: SavedNewsCategoryViewModelProtocol {
    
    func numberOfNewsCategories()-> Int {
        return NewsCategories.categories.count
    }
    
    func newsCategoryItem(index: Int)-> NewsCategoryModel {
        let category = NewsCategories.categories[index]
        return category
    }
    
    func selectNewsCategory(index: Int) {
        let savedCategory = UserDefaults.standard.object(forKey: "category") as? String ?? ""
        let category = newsCategoryItem(index: index)
        print(category.newsAbbreviation)
        if category.newsAbbreviation != savedCategory {
            UserDefaults.standard.setValue(category.newsAbbreviation, forKey: "category")
            NotificationCenter.default.post(name: Notification.Name("category"), object: category.newsAbbreviation)
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
            changedHandler?()
            HapticsManager.shared.hapticFeedback()
        } else {
            print("категория уже выбрана")
        }
    }
    
    func isNewsCategorySelected(index: Int)-> Bool {
        let savedCategory = UserDefaults.standard.object(forKey: "category") as? String ?? ""
        let category = newsCategoryItem(index: index)
        if category.newsAbbreviation == savedCategory {
            return true
        } else {
            return false
        }
    }
    
    func registerChangedHandler(block: @escaping()->Void) {
        self.changedHandler = block
    }
}
