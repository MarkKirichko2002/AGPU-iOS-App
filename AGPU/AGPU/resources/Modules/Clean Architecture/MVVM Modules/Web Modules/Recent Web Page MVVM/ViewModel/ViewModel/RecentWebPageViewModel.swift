//
//  RecentWebPageViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.07.2023.
//

import Foundation

final class RecentWebPageViewModel {
    
    var currentScrollPosition: scrollPositions?
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let dateManager = DateManager()
}
