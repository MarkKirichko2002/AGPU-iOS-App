//
//  ThingsCategoriesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.05.2024.
//

import Foundation

class ThingsCategoriesListViewModel {
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let settingsManager = SettingsManager()
    
}
