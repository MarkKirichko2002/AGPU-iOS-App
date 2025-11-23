//
//  MenuOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

final class MenuOptionsListViewModel {
    
    var options = [MenuOptionModel]()
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    var category: menuOptionCategories
    
    init(category: menuOptionCategories) {
        self.category = category
    }
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
}
