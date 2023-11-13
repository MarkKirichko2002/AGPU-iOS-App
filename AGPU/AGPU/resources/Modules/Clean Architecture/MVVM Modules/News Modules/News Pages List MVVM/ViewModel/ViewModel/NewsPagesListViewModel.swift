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
    
    var pages = [NewsPageModel]()
    
    var pageSelectedHandler: ((String)->Void)?
    var dataChangedHandler: (()->Void)?
    
    var abbreviation: String?
    
    var isStartLoading = false
    
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    
    // MARK: - Init
    init(currentPage: Int, countPages: Int, abbreviation: String?) {
        self.currentPage = currentPage
        self.countPages = countPages
        self.abbreviation = abbreviation
    }
}
