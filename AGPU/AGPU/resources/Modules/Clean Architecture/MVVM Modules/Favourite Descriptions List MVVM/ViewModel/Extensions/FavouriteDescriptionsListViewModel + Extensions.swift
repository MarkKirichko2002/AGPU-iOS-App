//
//  FavouriteDescriptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.09.2025.
//

import Foundation

// MARK: - IFavouriteTitlesListViewModel
extension FavouriteDescriptionsListViewModel: IFavouriteDescriptionsListViewModel {
    
    func descriptionsCount()-> Int {
        return descriptions.count
    }
    
    func descriptionItem(index: Int)-> String {
        return descriptions[index]
    }
    
    func addDescription(description: String) {
        if !description.isEmpty {
            if !descriptions.contains(description) {
                descriptions.append(description)
                saveArray(array: descriptions)
            }
        }
    }
    
    func getDescriptions() {
        descriptions = loadDescriptions()
        dataChangedHandler?()
    }
    
    func getChanges(index: Int) {
        descriptions = loadDescriptions()
        itemChangedHandler?(index)
    }
    
    func updateDescriptionInfo(description: String, name: String) {
        let index = descriptions.firstIndex { $0 == description }!
        if descriptions[index] != name {
            descriptions[index] = name
            saveChanges(description: name)
        }
    }
    
    func updateDescriptions(descriptions: [String], _ index: Int, _ index2: Int) {
        var arr = descriptions
        let item = arr.remove(at: index)
        arr.insert(item, at: index2)
        saveArray(array: arr)
    }
    
    func loadDescriptions()-> [String] {
        var data = [String]()
        if let result = UserDefaults.standard.object(forKey: "\(name) descriptions") as? Data {
            do {
                data = try JSONDecoder().decode([String].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func deleteDescription(description: String) {
        
        var descriptions = loadDescriptions()
        
        if let index = descriptions.firstIndex(where: { $0 == description }) {
            descriptions.remove(at: index)
        }
        HapticsManager.shared.hapticFeedback()
        saveArray(array: descriptions)
    }
    
    func saveArray(array: [String]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: "\(name) descriptions")
            getDescriptions()
        } catch {
            print(error)
        }
    }
    
    func saveChanges(description: String) {
        do {
            let arr = try JSONEncoder().encode(descriptions)
            UserDefaults.standard.setValue(arr, forKey: "\(name) descriptions")
            getChanges(index: descriptions.firstIndex(where: { $0 == description })!)
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
