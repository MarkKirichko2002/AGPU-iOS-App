//
//  AllMenuOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

final class AllMenuOptionsListViewModel {
    
    var category: menuOptionCategories
    var itemSelectedHandler: (()->Void)?
    var alertHandler: ((String, String)->Void)?
    
    init(category: menuOptionCategories) {
        self.category = category
    }
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
