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
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
