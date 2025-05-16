//
//  ASPUButtonGestureOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.12.2024.
//

import Foundation

// MARK: - IASPUButtonGestureOptionsListViewModel
extension ASPUButtonGestureOptionsListViewModel: IASPUButtonGestureOptionsListViewModel {
    
    func optionItem(index: Int)-> ASPUButtonGestureOptions {
        let option = ASPUButtonGestureOptions.allCases[index]
        return option
    }
    
    func optionItemsCount() -> Int {
        return ASPUButtonGestureOptions.allCases.count
    }
    
    func selectOption(index: Int) {
        let savedOption = settingsManager.checkASPUButtonGestureOption()
        let option = optionItem(index: index)
        if savedOption != option {
            UserDefaults.saveData(object: option, key: "gesture") {
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("action"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.dataSelectedHandler?()
            }
        }
    }
    
    func isOptionSelected(index: Int) -> Bool {
        let savedOption = settingsManager.checkASPUButtonGestureOption()
        let option = optionItem(index: index)
        if savedOption == option {
            return true
        }
        return false
    }
    
    func titleForNavigation()-> String {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return "Выберите жест"
        case .informal:
            return "Выбери жест"
        }
    }
    
    func registerDataSelectedHandler(block: @escaping()->Void) {
        self.dataSelectedHandler = block
    }
}
