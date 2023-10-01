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
    
    var faculty: AGPUFacultyModel?
    
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    
    // MARK: - Init
    init(currentPage: Int, countPages: Int, faculty: AGPUFacultyModel?) {
        self.currentPage = currentPage
        self.countPages = countPages
        self.faculty = faculty
    }
}
