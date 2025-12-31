//
//  ScreenMenuOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

final class ScreenMenuOptionsListViewModel {
    
    var options = [MenuOptionModel]()
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    var screen: menuCategoryScreens
    
    init(screen: menuCategoryScreens) {
        self.screen = screen
    }
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
}
