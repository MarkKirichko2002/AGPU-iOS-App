//
//  NewsPagesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 20.08.2023.
//

import Foundation

class NewsPagesListViewModel {
    
    var currentPage: Int = 0
    var countPages: Int = 0
    
    var pages = [Int]()
    
    var pageSelectedHandler: ((String)->Void)?
    var dataChangedHandler: (()->Void)?
    
    // MARK: - Init
    init(currentPage: Int, countPages: Int) {
        self.currentPage = currentPage
        self.countPages = countPages
    }
}
