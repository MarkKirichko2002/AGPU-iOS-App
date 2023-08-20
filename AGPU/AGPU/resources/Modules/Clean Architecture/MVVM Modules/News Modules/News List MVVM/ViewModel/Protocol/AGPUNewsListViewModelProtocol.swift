//
//  AGPUNewsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsListViewModelProtocol {
    func GetNewsByCurrentType()
    func GetAGPUNews()
    func GetFacultyNews(faculty: AGPUFacultyModel)
    func GetNews(by page: Int)
    func articleItem(index: Int)-> Article
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel?)->Void)
    func ObserveFacultyChanges()
    func ObservePageChanges()
    func makeUrlForCurrentArticle(index: Int)-> String
}
