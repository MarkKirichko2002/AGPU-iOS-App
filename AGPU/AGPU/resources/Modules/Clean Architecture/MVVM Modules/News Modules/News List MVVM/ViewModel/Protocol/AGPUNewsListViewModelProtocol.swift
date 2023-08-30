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
    func getFacultyNews(faculty: AGPUFacultyModel)
    func getNews(by page: Int)
    func refreshNews()
    func articleItem(index: Int)-> Article
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel?)->Void)
    func observeFacultyChanges()
    func observePageChanges()
    func makeUrlForCurrentArticle(index: Int)-> String
}
