//
//  SavedImagesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 09.05.2024.
//

import Foundation

class SavedImagesListViewModel {
    
    var dataChangedHandler:(()-> Void)?
    var images = [ImageModel]()
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let dateManager = DateManager()
}
