//
//  CurrentTabFavouriteOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2024.
//

import Foundation

final class CurrentTabFavouriteOptionsListViewModel {
    
    var options = [TabOptionModel]()
    var title: String
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    init(title: String) {
        self.title = title
    }
}
