//
//  AGPUNewsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

class AGPUNewsListViewModel {
    
    var newsResponse = NewsResponse(currentPage: 0, countPages: 0, articles: [])
    
    var abbreviation: String = ""
    var dataChangedHandler: ((String)->Void)?
   
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    
}
