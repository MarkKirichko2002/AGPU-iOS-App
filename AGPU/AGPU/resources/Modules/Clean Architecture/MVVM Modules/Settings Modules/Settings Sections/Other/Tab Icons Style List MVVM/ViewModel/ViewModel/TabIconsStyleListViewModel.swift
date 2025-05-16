//
//  TabIconsStyleListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.06.2024.
//

import Foundation

final class TabIconsStyleListViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    
}
