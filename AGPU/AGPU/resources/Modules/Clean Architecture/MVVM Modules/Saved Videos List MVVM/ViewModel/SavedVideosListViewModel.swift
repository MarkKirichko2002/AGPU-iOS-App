//
//  SavedVideosListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 02.06.2024.
//

import Foundation

final class SavedVideosListViewModel {
    
    var videos = [VideoModel]()
    
    var alertHandler: (()-> Void)?
    var dataChangedHandler: (()-> Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let dateManager = DateManager()
    let settingsManager = SettingsManager()
    
}
