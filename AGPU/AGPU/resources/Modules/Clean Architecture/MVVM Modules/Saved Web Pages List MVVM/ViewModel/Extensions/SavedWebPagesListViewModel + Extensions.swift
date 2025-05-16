//
//  SavedWebPagesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.04.2025.
//

import UIKit

// MARK: - ISavedWebPagesListViewModel
extension SavedWebPagesListViewModel: ISavedWebPagesListViewModel {
    
    func pagesCount()-> Int {
        return pages.count
    }
    
    func pageItem(index: Int)-> WebPageModel {
        return pages[index]
    }
    
    func savePage(page: WebPageModel) {
        if isValidURL(url: page.url) {
            realmManager.saveWebPage(page: page)
            getPages()
        } else {
            alertHandler?()
        }
    }
    
    func getChanges(index: Int) {
        pages = realmManager.getWebPages()
        itemChangedHandler?(index)
    }
    
    func getPages() {
        pages = realmManager.getWebPages()
        dataChangedHandler?()
    }
    
    func editPage(page: WebPageModel, name: String) {
        let index = pages.firstIndex { $0.id == page.id }!
        if pages[index].name != name {
            realmManager.editWebPage(page: page, name: name)
            getChanges(index: index)
        }
    }
    
    func updatePages(pages: [WebPageModel], _ index: Int, _ index2: Int) {
        realmManager.updateWebPages(pages: pages, index, index2)
        getPages()
    }
    
    func deletePage(page: WebPageModel) {
        realmManager.deleteWebPage(page: page)
        getPages()
    }
    
    func getCurrentDate()-> String {
        return dateManager.getCurrentDate()
    }
    
    func isValidURL(url: String)-> Bool {
        return UIApplication.shared.isValidURL(url: url)
    }
    
    func createAddAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Добавить web-страницу", "\(!name.isEmpty ? "\(name) введите" : "Введите") данные для web-страницы")
        case .informal:
            return ("Добавить web-страницу", "\(!name.isEmpty ? "\(name) введи" : "Введи") данные для web-страницы")
        }
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить web-страницу", "\(!name.isEmpty ? "\(name) вы точно хотите изменить" : "Вы точно хотите изменить") данные для web-страницы?")
        case .informal:
            return ("Изменить web-страницу", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") данные для web-страницы?")
        }
    }
    
    func createTextForEditAlert()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return ("Введите имя", "Введите URL")
        case .informal:
            return ("Введи имя", "Введи URL")
        }
    }
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Данные не введены!", "\(!name.isEmpty ? "\(name) введите" : "Введите") данные для web-страницы")
        case .informal:
            return ("Данные не введены!", "\(!name.isEmpty ? "\(name) введи" : "Введи") данные в текстовых полях")
        }
    }
    
    func registerAlertHandler(block: @escaping()->Void) {
        self.alertHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)->Void) {
        self.itemChangedHandler = block
    }
}
