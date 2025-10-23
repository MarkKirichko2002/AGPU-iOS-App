//
//  FavouriteDescriptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.09.2025.
//

import Foundation

final class FavouriteDescriptionsListViewModel {
    
    var descriptions = [String]()
    var name = ""
    
    init(name: String) {
        self.name = name
    }
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
}
