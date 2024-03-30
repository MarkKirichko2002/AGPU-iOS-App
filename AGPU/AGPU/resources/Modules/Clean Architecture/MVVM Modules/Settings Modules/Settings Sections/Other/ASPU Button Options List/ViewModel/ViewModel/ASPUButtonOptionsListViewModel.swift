//
//  ASPUButtonOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import Foundation

class ASPUButtonOptionsListViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    
}
