//
//  RecentMomentsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import Foundation

class RecentMomentsListViewModel {
    
    let style = SettingsManager().getSavedCommunicationStyle()
    let name = UserDefaults.standard.string(forKey: "name") ?? ""
    
    var alertHandler: ((String, String)->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
}
