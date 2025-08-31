//
//  FavouriteTitlesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2025.
//

import Foundation

final class FavouriteTitlesListViewModel {
    
    var titles = [String]()
    var name = ""
    
    init(name: String) {
        self.name = name
    }
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
}
