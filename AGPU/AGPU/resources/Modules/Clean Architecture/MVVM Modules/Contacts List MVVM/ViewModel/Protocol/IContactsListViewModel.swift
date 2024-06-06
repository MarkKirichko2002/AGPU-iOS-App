//
//  IContactsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 05.06.2024.
//

import Foundation

protocol IContactsListViewModel {
    func contactsCount()-> Int
    func contactItem(index: Int)-> ContactModel
    func saveContact(contact: ContactModel)
    func getContacts()
    func editContact(contact: ContactModel, name: String, number: String)
    func deleteContact(contact: ContactModel)
    func registerDataChangedHandler(block: @escaping()->Void)
}
