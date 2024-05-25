//
//  TodayNewsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 25.05.2024.
//

import Foundation

class TodayNewsListViewModel {
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let newsService = AGPUNewsService()
    
    var dataChangedHandler: (()->Void)?
    var sections = [TodayNewsSectionModel]()
    
}
