//
//  SavedWebPagesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.04.2025.
//

import Foundation

final class SavedWebPagesListViewModel {
    
    var pages = [WebPageModel]()
    
    var alertHandler: (()->Void)?
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let settingsManager = SettingsManager()
    let dateManager = DateManager()
    
}
