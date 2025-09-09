//
//  AGPUNewsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsListViewModelProtocol {
    func articleItem(index: Int)-> Article
    func getNewsByCurrentType()
    func getAGPUNews()
    func getNews(abbreviation: String)
    func getNews(by page: Int, completion: @escaping()->Void)
    func refreshNews()
    func observeCategoryChanges()
    func observeFilterOption()
    func observeStrokeOption()
    func filterNews(option: NewsOptionsFilters)
    func makeUrlForCurrentArticle(index: Int)-> String
    func makeUrlForCurrentWebPage()-> String
    func registerDataChangedHandler(block: @escaping(String)->Void)
}
