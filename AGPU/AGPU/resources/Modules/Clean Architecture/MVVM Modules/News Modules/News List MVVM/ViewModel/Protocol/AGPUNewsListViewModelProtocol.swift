//
//  AGPUNewsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsListViewModelProtocol {
    func GetNewsByCurrentType()
    func GetFacultyNews(faculty: AGPUFacultyModel)
    func GetAGPUNews()
    func GetNews(by page: Int)
    func articleItem(index: Int)-> Article
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel?)->Void)
    func ObserveFacultyChanges()
    func ObservedPageChanges()
    func makeUrlForCurrentArticle(index: Int)-> String
}
