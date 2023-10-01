//
//  NewsCategoriesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2023.
//

import Foundation

class NewsCategoriesListViewModel {
    
    var currentCategory = ""
    
    var categorySelectedHandler: ((String)->Void)?
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    
    // MARK: - Init
    init(currentCategory: String) {
        self.currentCategory = currentCategory
    }
}
