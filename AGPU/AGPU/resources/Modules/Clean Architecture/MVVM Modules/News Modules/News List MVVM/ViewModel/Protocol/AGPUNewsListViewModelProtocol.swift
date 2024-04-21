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
    func getNews(by page: Int)
    func getRandomNews()
    func refreshNews()
    func observeCategoryChanges()
    func observePageChanges()
    func observeFilterOption()
    func observeStrokeOption()
    func filterNews(option: NewsOptionsFilters)
    func makeUrlForCurrentArticle(index: Int)-> String
    func makeUrlForCurrentWebPage()-> String
    func sendNotificationArticleWasSelected()
    func registerCategoryChangedHandler(block: @escaping(String)->Void)
}
