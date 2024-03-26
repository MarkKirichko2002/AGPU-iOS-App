//
//  TabsListTableViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import Foundation

class TabsListTableViewModel {
    
    var tabs = TabsList.tabs
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
