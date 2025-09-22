//
//  NewsFavouriteOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

final class NewsFavouriteOptionsListViewModel {
    
    var currentOption = NewsOptions.list[0]
    var options = [NewsOptionModel]()
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
