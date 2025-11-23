//
//  AllMenuOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

// MARK: - IAllNewsOptionsListViewModel
extension AllMenuOptionsListViewModel: IAllMenuOptionsListViewModel {
    
    func optionsCount()-> Int {
        return category.options.count
    }
    
    func optionItem(index: Int)-> MenuOptionModel {
        return category.options[index]
    }
    
    func selectOption(index: Int) {
        let option = optionItem(index: index)
        saveOption(option: option)
    }
    
    func saveOption(option: MenuOptionModel) {
        var options = settingsManager.loadMenuOptions(category: category.rawValue)
        if !options.contains(where: { $0.id == option.id }) {
            HapticsManager.shared.hapticFeedback()
            options.append(option)
        }
        settingsManager.saveMenuOptions(category: category.rawValue, options: options) {
            self.itemSelectedHandler?()
        }
    }
    
    func saveOptions(options: [MenuOptionModel]) {
        var savedOptions = settingsManager.loadMenuOptions(category: category.rawValue)
        for option in options {
            if !savedOptions.contains(where: { $0.id == option.id }) {
                savedOptions.append(option)
            }
        }
        settingsManager.saveMenuOptions(category: category.rawValue, options: savedOptions) {
            self.itemSelectedHandler?()
        }
    }
    
    func registerItemSelectedHandler(block: @escaping() -> Void) {
        self.itemSelectedHandler = block
    }
}
