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
    
    func createAddAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Добавить контакт", "\(!name.isEmpty ? "\(name) введите" : "Введите") данные для контакта")
        case .informal:
            return ("Добавить контакт", "\(!name.isEmpty ? "\(name) введи" : "Введи") данные для контакта")
        }
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить контакт", "\(!name.isEmpty ? "\(name) вы точно хотите изменить" : "Вы точно хотите изменить") данные для контакта?")
        case .informal:
            return ("Изменить контакт", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") данные для контакта?")
        }
    }
    
    // Вы точно хотите изменить данные контакта?
    
    func createTextForEditAlert()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return ("Введите имя", "Введите номер")
        case .informal:
            return ("Введи имя", "Введи номер")
        }
    }
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Данные не введены!", "\(!name.isEmpty ? "\(name) введите" : "Введите") данные для контакта")
        case .informal:
            return ("Данные не введены!", "\(!name.isEmpty ? "\(name) введи" : "Введи") данные в текстовых полях")
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
