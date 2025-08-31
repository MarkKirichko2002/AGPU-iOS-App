//
//  FavouriteTitlesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2025.
//

import Foundation

// MARK: - IFavouriteTitlesListViewModel
extension FavouriteTitlesListViewModel: IFavouriteTitlesListViewModel {
    
    func titlesCount()-> Int {
        return titles.count
    }
    
    func titleItem(index: Int)-> String {
        return titles[index]
    }
    
    func addTitle(title: String) {
        if !title.isEmpty {
            if !titles.contains(title) {
                titles.append(title)
                saveArray(array: titles)
            }
        }
    }
    
    func getTitles() {
        titles = loadTitles()
        dataChangedHandler?()
    }
    
    func getChanges(index: Int) {
        titles = loadTitles()
        itemChangedHandler?(index)
    }
    
    func updateTitleInfo(title: String, name: String) {
        let index = titles.firstIndex { $0 == title }!
        if titles[index] != name {
            titles[index] = name
            saveChanges(title: name)
        }
    }
    
    func updateTitles(titles: [String], _ index: Int, _ index2: Int) {
        var arr = titles
        let item = arr.remove(at: index)
        arr.insert(item, at: index2)
        saveArray(array: arr)
    }
    
    func loadTitles()-> [String] {
        var data = [String]()
        if let result = UserDefaults.standard.object(forKey: "\(name) titles") as? Data {
            do {
                data = try JSONDecoder().decode([String].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func deleteTitle(title: String) {
        
        var titles = loadTitles()
        
        if let index = titles.firstIndex(where: { $0 == title }) {
            titles.remove(at: index)
        }
        HapticsManager.shared.hapticFeedback()
        saveArray(array: titles)
    }
    
    func saveArray(array: [String]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: "\(name) titles")
            getTitles()
        } catch {
            print(error)
        }
    }
    
    func saveChanges(title: String) {
        do {
            let arr = try JSONEncoder().encode(titles)
            UserDefaults.standard.setValue(arr, forKey: "\(name) titles")
            getChanges(index: titles.firstIndex(where: { $0 == title })!)
        } catch {
            print(error)
        }
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить название", "\(!name.isEmpty ? "\(name) вы точно хотите изменить" : "Вы точно хотите изменить") название?")
        case .informal:
            return ("Изменить название", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") название?")
        }
    }
    
    func createAddAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Добавить название", "\(!name.isEmpty ? "\(name) введите" : "Введите") название")
        case .informal:
            return ("Добавить название", "\(!name.isEmpty ? "\(name) введи" : "Введи") название")
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)->Void) {
        self.itemChangedHandler = block
    }
}
