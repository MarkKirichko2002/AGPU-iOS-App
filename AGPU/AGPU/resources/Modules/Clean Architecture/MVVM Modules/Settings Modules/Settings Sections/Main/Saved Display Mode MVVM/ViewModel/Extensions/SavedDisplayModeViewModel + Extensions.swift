//
//  SavedDisplayModeViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 01.05.2024.
//

import Foundation

// MARK: - ISavedDisplayModeViewModel
extension SavedDisplayModeViewModel: ISavedDisplayModeViewModel {
    
    func optionItem(index: Int)-> DisplayModes {
        let option = DisplayModes.allCases[index]
        return option
    }
    
    func numberOfOptionsInSection()-> Int {
        let count = DisplayModes.allCases.count
        return count
    }
    
    func chooseOption(index: Int) {
        let savedOption = UserDefaults.loadData(type: DisplayModes.self, key: "display mode") ?? .grid
        let item = optionItem(index: index)
        if savedOption != item {
            saveOption(option: item)
        } else {
            print("уже выбрана")
        }
    }
    
    func saveOption(option: DisplayModes) {
        UserDefaults.saveData(object: option, key: "display mode") {
            HapticsManager.shared.hapticFeedback()
            NotificationCenter.default.post(name: Notification.Name("display mode option"), object: option)
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
            self.optionSelectedHandler?()
        }
    }
    
    func isCurrentOption(index: Int)-> Bool {
        let savedOption = UserDefaults.loadData(type: DisplayModes.self, key: "display mode") ?? .grid
        let item = optionItem(index: index)
        if savedOption == item {
            return true
        }
        return false
    }
    
    func registerOptionSelectedHandler(block: @escaping(()->Void)) {
        self.optionSelectedHandler = block
    }
}
