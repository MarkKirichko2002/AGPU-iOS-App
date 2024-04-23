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
    var option = NewsOptionsFilters.all
    var displayMode = DisplayModes.grid
    var isLoaded = false
    var allNews = [Article]()
    
    var dataChangedHandler: ((String)->Void)?
    var dataIsLoadedHandler: (()->Void)?
    var dislayModeHandler: ((DisplayModes)->Void)?
    var webModeHandler: (()->Void)?
    
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    let dateManager = DateManager()
    
}
