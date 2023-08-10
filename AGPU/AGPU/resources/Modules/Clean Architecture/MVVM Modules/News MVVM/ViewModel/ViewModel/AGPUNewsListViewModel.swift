//
//  AGPUNewsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

class AGPUNewsListViewModel {
    
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    
    var newsResponse = NewsResponse(currentPage: 0, countPages: 0, articles: [])
    
    var dataChangedHandler: ((AGPUFacultyModel?)->Void)?
   
    var faculty: AGPUFacultyModel?
}
