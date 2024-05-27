//
//  IThingsCategoriesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.05.2024.
//

import Foundation

protocol IThingsCategoriesListViewModel {
    func categoryItem(index: Int)-> ThingCategoryModel
    func categoriesCount()-> Int
    func getCategoriesData()
    func registerDataChangedHandler(block: @escaping()->Void)
}
