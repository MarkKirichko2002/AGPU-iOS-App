//
//  NewsOptionsFilterListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 05.04.2024.
//

import Foundation

final class NewsOptionsFilterListViewModel {
    
    var option = NewsOptionsFilters.all
    var options = NewsOptionsFilters.allCases
    var optionSelectedHandler: (()->Void)?
    var news = [Article]()
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let realmManager = RealmManager()
    
    // MARK: - Init
    init(option: NewsOptionsFilters, news: [Article]) {
        self.option = option
        self.news = news
    }
}
