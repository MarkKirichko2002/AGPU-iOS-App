//
//  FavouriteShortcutsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.12.2024.
//

import Foundation

final class FavouriteShortcutsListViewModel {
    
    var shortcuts = [ShortcutModel]()
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
