//
//  ASPUButtonAnimationOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.04.2024.
//

import Foundation

// MARK: - IASPUButtonAnimationOptionsListViewModel
extension ASPUButtonAnimationOptionsListViewModel: IASPUButtonAnimationOptionsListViewModel {
    
    func optionItem(index: Int)-> ASPUButtonAnimationOptions {
        let option = ASPUButtonAnimationOptions.allCases[index]
        return option
    }
    
    func optionItemsCount() -> Int {
        return ASPUButtonAnimationOptions.allCases.count
    }
    
    func selectOption(index: Int) {
        let savedOption = settingsManager.checkASPUButtonAnimationOption()
        let option = optionItem(index: index)
        if savedOption != option {
            UserDefaults.saveData(object: option, key: "animation") {
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.dataSelectedHandler?()
            }
        }
    }
    
    func isOptionSelected(index: Int) -> Bool {
        let savedOption = settingsManager.checkASPUButtonAnimationOption()
        let option = optionItem(index: index)
        if savedOption == option {
            return true
        }
        return false
    }
    
    func registerDataSelectedHandler(block: @escaping()->Void) {
        self.dataSelectedHandler = block
    }
}
