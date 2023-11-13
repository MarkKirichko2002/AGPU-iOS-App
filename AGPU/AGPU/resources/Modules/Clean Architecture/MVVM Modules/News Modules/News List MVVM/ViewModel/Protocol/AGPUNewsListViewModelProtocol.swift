//
//  AGPUNewsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsListViewModelProtocol {
    func getNewsByCurrentType()
    func getAGPUNews()
    func getFacultyNews(abbreviation: String)
    func getNews(by page: Int)
    func refreshNews()
    func articleItem(index: Int)-> Article
    func registerCategoryChangedHandler(block: @escaping(String)->Void)
    func observeCategoryChanges()
    func observePageChanges()
    func makeUrlForCurrentArticle(index: Int)-> String
}
