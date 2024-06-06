//
//  ContactsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 05.06.2024.
//

import Foundation

// MARK: - IContactsListViewModel
extension ContactsListViewModel: IContactsListViewModel {
    
    func contactsCount()-> Int {
        return contacts.count
    }
    
    func contactItem(index: Int)-> ContactModel {
        return contacts[index]
    }
    
    func saveContact(contact: ContactModel) {
        realmManager.saveContact(contact: contact)
        getContacts()
    }
    
    func getContacts() {
        contacts = realmManager.getContacts()
        dataChangedHandler?()
    }
    
    func editContact(contact: ContactModel, name: String, number: String) {
        realmManager.editContact(contact: contact, name: name, number: number)
        getContacts()
    }
    
    func deleteContact(contact: ContactModel) {
        realmManager.deleteContact(contact: contact)
        getContacts()
    }
        
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
