//
//  ContactsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 05.06.2024.
//

import Foundation

class ContactsListViewModel {
    
    var contacts = [ContactModel]()
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let realmManager = RealmManager()
    
}
