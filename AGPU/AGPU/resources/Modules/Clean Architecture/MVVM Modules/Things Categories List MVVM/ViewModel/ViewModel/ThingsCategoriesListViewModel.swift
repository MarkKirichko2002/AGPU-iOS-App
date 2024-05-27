//
//  ThingsCategoriesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.05.2024.
//

import Foundation

class ThingsCategoriesListViewModel {
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    
    var dataChangedHandler: (()->Void)?
    
}
