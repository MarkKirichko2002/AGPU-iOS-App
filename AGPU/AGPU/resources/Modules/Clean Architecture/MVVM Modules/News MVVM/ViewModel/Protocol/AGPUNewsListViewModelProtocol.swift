//
//  AGPUNewsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import UIKit

protocol AGPUNewsListViewModelProtocol {
    func GetNews()
    func articleItem(index: Int)-> Article
    func registerDataChangedHandler(block: @escaping(AGPUFacultyModel?)->Void)
    func ObserveFacultyChanges()
    func urlForCurrentArticle(index: Int)-> String
    func pagesMenu()-> UIMenu
}
