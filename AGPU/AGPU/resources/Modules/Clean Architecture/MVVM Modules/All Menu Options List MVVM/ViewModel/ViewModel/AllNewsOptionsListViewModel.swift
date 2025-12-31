//
//  AllScreenMenuOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

final class AllScreenMenuOptionsListViewModel {
    
    var screen: menuCategoryScreens
    var itemSelectedHandler: (()->Void)?
    var alertHandler: ((String, String)->Void)?
    
    init(screen: menuCategoryScreens) {
        self.screen = screen
    }
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
