//
//  DisplayModeOptionsListViewModel  + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.04.2024.
//

import Foundation

// MARK: - IDisplayModeOptionsListViewModel
extension DisplayModeOptionsListViewModel: IDisplayModeOptionsListViewModel {
    
    func optionItem(index: Int)-> DisplayModes {
        let option = DisplayModes.allCases[index]
        return option
    }
    
    func numberOfOptionsInSection()-> Int {
        let count = DisplayModes.allCases.count
        return count
    }
    
    func chooseOption(index: Int) {
        let item = optionItem(index: index)
        if option != item {
            option = item
            optionSelectedHandler?()
            HapticsManager.shared.hapticFeedback()
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
        let item = optionItem(index: index)
        if option == item {
            return true
        }
        return false
    }
    
    func registerOptionSelectedHandler(block: @escaping(()->Void)) {
        self.optionSelectedHandler = block
    }
}
