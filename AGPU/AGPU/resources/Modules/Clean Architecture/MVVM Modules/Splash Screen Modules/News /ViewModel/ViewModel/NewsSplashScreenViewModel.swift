//
//  NewsSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.03.2024.
//

import Foundation

class NewsSplashScreenViewModel {
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let newsService = AGPUNewsService()
    
    var news = [Article]()
    var newsHandler: ((NewsCategoryDescriptionModel)->Void)?
    
}
