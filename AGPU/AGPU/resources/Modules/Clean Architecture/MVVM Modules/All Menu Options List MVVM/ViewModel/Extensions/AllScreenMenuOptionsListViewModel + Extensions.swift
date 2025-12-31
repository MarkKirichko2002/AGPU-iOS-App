//
//  AllScreenMenuOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

// MARK: - IAllScreenMenuOptionsListViewModel
extension AllScreenMenuOptionsListViewModel: IAllScreenMenuOptionsListViewModel {
    
    func optionsCount()-> Int {
        return screen.options.count
    }
    
    func optionItem(index: Int)-> MenuOptionModel {
        return screen.options[index]
    }
    
    func selectOption(index: Int) {
        let option = optionItem(index: index)
        saveOption(option: option)
    }
    
    func saveOption(option: MenuOptionModel) {
        var options = settingsManager.loadMenuOptions(category: screen.rawValue)
        if !options.contains(where: { $0.id == option.id }) {
            HapticsManager.shared.hapticFeedback()
            options.append(option)
        }
        settingsManager.saveMenuOptions(category: screen.rawValue, options: options) {
            self.itemSelectedHandler?()
        }
    }
    
    func saveOptions(options: [MenuOptionModel]) {
        var savedOptions = settingsManager.loadMenuOptions(category: screen.rawValue)
        for option in options {
            if !savedOptions.contains(where: { $0.id == option.id }) {
                savedOptions.append(option)
            }
        }
        settingsManager.saveMenuOptions(category: screen.rawValue, options: savedOptions) {
            self.itemSelectedHandler?()
        }
    }
    
    func registerItemSelectedHandler(block: @escaping() -> Void) {
        self.itemSelectedHandler = block
    }
}
