//
//  NewsOptionsFilterListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 05.04.2024.
//

import Foundation

class NewsOptionsFilterListViewModel {
    
    var option = NewsOptionsFilters.all
    var optionSelectedHandler: (()->Void)?
    
    // MARK: - Init
    init(option: NewsOptionsFilters) {
        self.option = option
    }
}
