//
//  NewsCategoriesListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2023.
//

import Foundation

protocol NewsCategoriesListViewModelProtocol {
    func categoryItem(index: Int)-> NewsCategoryModel
    func numberOfCategoriesInSection()-> Int
    func getNewsCategoriesInfo()
    func countTodayNews(news: [Article])-> Int
    func chooseNewsCategory(index: Int)
    func isCurrentCategory(index: Int)-> Bool
    func registerCategorySelectedHandler(block: @escaping((String)->Void))
    func registerDataChangedHandler(block: @escaping()->Void)
}
