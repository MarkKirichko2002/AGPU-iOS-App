//
//  SavedNewsCategoryViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.11.2023.
//

import Foundation

protocol SavedNewsCategoryViewModelProtocol {
    func numberOfNewsCategories()-> Int
    func newsCategoryItem(index: Int)-> NewsCategoryModel
    func selectNewsCategory(index: Int)
    func isNewsCategorySelected(index: Int)-> Bool
    func registerChangedHandler(block: @escaping()->Void)
}
