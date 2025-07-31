//
//  CurrentTabFavouriteOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2024.
//

import Foundation

// MARK: - ICurrentTabFavouriteOptionsListViewModel
extension CurrentTabFavouriteOptionsListViewModel: ICurrentTabFavouriteOptionsListViewModel {
    
    func optionsCount()-> Int {
        return options.count
    }
    
    func optionItem(index: Int)-> TabOptionModel {
        return options[index]
    }
    
    func getOptions() {
        options = loadOptions()
        dataChangedHandler?()
    }
    
    func updateOptions(options: [TabOptionModel], _ index: Int, _ index2: Int) {
        
        var arr = options
        
        let item = arr.remove(at: index)
        arr.insert(item, at: index2)
        
        saveArray(array: arr)
    }
    
    func loadOptions()-> [TabOptionModel] {
        var data = [TabOptionModel]()
        if let result = UserDefaults.standard.object(forKey: "\(title) options") as? Data {
            do {
                data = try JSONDecoder().decode([TabOptionModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func deleteOption(option: TabOptionModel) {
        
        var options = loadOptions()
        
        if let index = options.firstIndex(where: { $0.title == option.title }) {
            options.remove(at: index)
        }
        HapticsManager.shared.hapticFeedback()
        saveArray(array: options)
    }
    
    func saveArray(array: [TabOptionModel]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: "\(title) options")
            getOptions()
        } catch {
            print(error)
        }
    }
    
    func editText(option: TabOptionModel, text: String) {
        let options = loadOptions()
        let index = options.firstIndex(of: option) ?? 0
        if self.options[index].title != text {
            self.options[index].title = text
            saveChanges(option: option)
        }
    }
    
    func resetTitle(option: TabOptionModel) {
        let options = loadOptions()
        let searchSection = TabOptionsSections.sections.first { $0.title == title}!
        let searchOption = searchSection.options.first {$0.id == option.id}!
        let index = options.firstIndex(of: option) ?? 0
        if self.options[index].title != searchOption.title {
            self.options[index].title = searchOption.title
            saveChanges(option: searchOption)
        }
    }
    
    func saveChanges(option: TabOptionModel) {
        do {
            let arr = try JSONEncoder().encode(options)
            UserDefaults.standard.setValue(arr, forKey: "\(title) options")
            getChanges(index: options.firstIndex(where: { $0.id == option.id })!)
        } catch {
            print(error)
        }
    }
    
    func getChanges(index: Int) {
        options = loadOptions()
        itemChangedHandler?(index)
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить опцию", "\(!name.isEmpty ? "\(name) Вы точно хотите изменить" : "Вы точно хотите изменить") название опции?")
        case .informal:
            return ("Изменить опцию", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") название опции?")
        }
    }
    
    func createTextInfoForOption(option: TabOptionModel)-> (String, String) {
        let searchSection = TabOptionsSections.sections.first { $0.title == title}!
        let searchOption = searchSection.options.first {$0.id == option.id}!
        return (searchSection.title.getCurrentTabName(), searchOption.title)
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)->Void) {
        self.itemChangedHandler = block
    }
}
