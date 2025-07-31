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
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    init(title: String) {
        self.title = title
    }
}
