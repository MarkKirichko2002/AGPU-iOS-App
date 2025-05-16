//
//  ContactsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 05.06.2024.
//

import Foundation

final class ContactsListViewModel {
    
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    var contacts = [ContactModel]()
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    let settingsManager = SettingsManager()
    
}
