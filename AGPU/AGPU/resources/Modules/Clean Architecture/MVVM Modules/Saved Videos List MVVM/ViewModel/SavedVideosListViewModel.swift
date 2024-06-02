//
//  SavedVideosListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 02.06.2024.
//

import Foundation

class SavedVideosListViewModel {
    
    var dataChangedHandler:(()-> Void)?
    var videos = [VideoModel]()
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let dateManager = DateManager()

}
