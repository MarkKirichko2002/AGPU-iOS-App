//
//  GlanceInfoOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2025.
//

import Foundation

class GlanceInfoOptionsListViewModel {
    
    var options = GlanceInfoOptions.options
    var dataChangedHandler: (()->Void)?
    var ownerHandler: ((String)->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
