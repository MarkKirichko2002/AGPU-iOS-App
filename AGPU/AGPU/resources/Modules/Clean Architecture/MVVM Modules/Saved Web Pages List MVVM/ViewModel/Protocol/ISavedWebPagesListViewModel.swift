//
//  ISavedWebPagesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.04.2025.
//

import Foundation

protocol ISavedWebPagesListViewModel {
    func pagesCount()-> Int
    func pageItem(index: Int)-> WebPageModel
    func savePage(page: WebPageModel)
    func getPages()
    func editPage(page: WebPageModel, name: String)
    func deletePage(page: WebPageModel)
    func registerDataChangedHandler(block: @escaping()->Void)
    func registerItemChangedHandler(block: @escaping(Int)->Void)
}
