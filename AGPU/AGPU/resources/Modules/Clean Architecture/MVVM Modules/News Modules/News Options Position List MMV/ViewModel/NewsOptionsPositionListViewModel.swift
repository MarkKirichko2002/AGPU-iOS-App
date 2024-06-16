//
//  NewsOptionsPositionListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.06.2024.
//

import Foundation

class NewsOptionsPositionListViewModel {
    
    var options = NewsOptions.list
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
