//
//  TabsPositionListTableViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import Foundation

final class TabsPositionListTableViewModel {
    
    var tabs = TabsList.tabs
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
}
