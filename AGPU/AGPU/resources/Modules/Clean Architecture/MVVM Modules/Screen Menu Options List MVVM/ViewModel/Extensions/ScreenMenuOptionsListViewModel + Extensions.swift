//
//  IScreenMenuOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

// MARK: - IScreenMenuOptionsListViewModel
extension ScreenMenuOptionsListViewModel: IScreenMenuOptionsListViewModel {
    
    func optionsCount()-> Int {
        return options.count
    }
    
    func optionItem(index: Int)-> MenuOptionModel {
        return options[index]
    }
    
    func getOptions() {
        options = settingsManager.loadMenuOptions(category: screen.rawValue)
        dataChangedHandler?()
    }
    
    func updateOptions(options: [MenuOptionModel], _ index: Int, _ index2: Int) {
        var arr = options
        let item = arr.remove(at: index)
        arr.insert(item, at: index2)
        settingsManager.saveMenuOptions(category: screen.rawValue, options: arr) {
            self.getOptions()
        }
    }
    
    func deleteOption(option: MenuOptionModel) {
        var options = settingsManager.loadMenuOptions(category: screen.rawValue)
        if let index = options.firstIndex(where: { $0.id == option.id }) {
            options.remove(at: index)
        }
        HapticsManager.shared.hapticFeedback()
        settingsManager.saveMenuOptions(category: screen.rawValue, options: options) {
            self.getOptions()
        }
    }
    
    func registerDataChangedHandler(block: @escaping() -> Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)->Void) {
        self.itemChangedHandler = block
    }
}
