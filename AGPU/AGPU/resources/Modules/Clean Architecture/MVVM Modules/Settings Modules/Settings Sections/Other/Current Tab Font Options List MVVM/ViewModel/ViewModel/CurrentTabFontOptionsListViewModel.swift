//
//  CurrentTabFontOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.12.2024.
//

import Foundation

final class CurrentTabFontOptionsListViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var title: String
    var dataChangedHandler: (()->Void)?
    
    init(title: String) {
        self.title = title
    }
}
