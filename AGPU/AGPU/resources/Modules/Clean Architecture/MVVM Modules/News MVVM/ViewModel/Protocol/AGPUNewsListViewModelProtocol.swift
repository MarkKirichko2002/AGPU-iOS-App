//
//  AGPUNewsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

protocol AGPUNewsListViewModelProtocol {
    func GetNews()
    func articleItem(index: Int)-> NewsModel
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel)->Void)
    func ObserveFacultyChanges()
    func urlForCurrentArticle(index: Int)-> String
}
