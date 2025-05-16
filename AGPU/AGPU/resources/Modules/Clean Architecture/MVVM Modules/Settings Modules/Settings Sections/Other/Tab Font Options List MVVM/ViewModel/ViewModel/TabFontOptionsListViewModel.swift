//
//  TabFontOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.12.2024.
//

import Foundation

final class TabFontOptionsListViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    
}
