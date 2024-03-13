//
//  RecentNewsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.03.2024.
//

import Foundation

class RecentNewsListViewModel {
    
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    let realmManager = RealmManager()
    
    var news = [NewsModel]()
    var dataChangedHandler: (()->Void)?
    
}
