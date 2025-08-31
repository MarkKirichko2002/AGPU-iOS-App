//
//  FavouriteShortcutsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.12.2024.
//

import Foundation

final class FavouriteShortcutsListViewModel {
    
    var currentShortCut = ShortcutModel(id: "", title: "", subtitle: "", icon: "")
    var shortcuts = [ShortcutModel]()
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
