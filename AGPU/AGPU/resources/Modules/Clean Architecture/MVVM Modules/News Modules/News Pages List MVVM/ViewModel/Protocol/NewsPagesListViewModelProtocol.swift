//
//  NewsPagesListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 20.08.2023.
//

import Foundation

protocol NewsPagesListViewModelProtocol {
    func currentNewsCategoryIcon()-> String
    func pageItem(index: Int)-> String
    func numberOfPagesInSection()-> Int
    func setUpData()
    func getNewsPagesInfo()
    func chooseNewsPage(index: Int)
    func isCurrentPage(index: Int)-> Bool
    func registerPageSelectedHandler(block: @escaping((String)->Void))
    func registerDataChangedHandler(block: @escaping()->Void)
}
