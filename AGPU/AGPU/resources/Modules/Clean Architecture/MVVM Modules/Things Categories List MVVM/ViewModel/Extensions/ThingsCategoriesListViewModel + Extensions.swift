//
//  ThingsCategoriesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 28.05.2024.
//

import Foundation

// MARK: - IThingsCategoriesListViewModel
extension ThingsCategoriesListViewModel: IThingsCategoriesListViewModel {
    
    func categoryItem(index: Int)-> ThingCategoryModel {
        return ThingCategories.categories[index]
    }
    
    func categoriesCount()-> Int {
        return ThingCategories.categories.count
    }
    
    func getCategoriesData() {
        ThingCategories.categories[0].itemsCount = realmManager.getDocuments().count
        ThingCategories.categories[1].itemsCount = realmManager.getImages().count
        ThingCategories.categories[2].itemsCount = realmManager.getVideos().count
        dataChangedHandler?()
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
