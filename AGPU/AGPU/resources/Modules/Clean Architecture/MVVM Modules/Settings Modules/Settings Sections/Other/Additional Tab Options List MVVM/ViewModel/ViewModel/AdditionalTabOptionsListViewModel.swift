//
//  AdditionalTabOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 25.12.2024.
//

import Foundation

final class AdditionalTabOptionsListViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    
}
