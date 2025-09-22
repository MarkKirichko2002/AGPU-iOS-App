//
//  AllNewsOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

final class AllNewsOptionsListViewModel {
    
    var itemSelectedHandler: (()->Void)?
    var alertHandler: ((String, String)->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
