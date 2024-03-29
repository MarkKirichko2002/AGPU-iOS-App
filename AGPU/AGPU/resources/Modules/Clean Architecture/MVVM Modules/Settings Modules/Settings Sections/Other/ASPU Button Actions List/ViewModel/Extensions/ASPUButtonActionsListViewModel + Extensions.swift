//
//  ASPUButtonActionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import Foundation

// MARK: - ASPUButtonActionsListViewModelProtocol
extension ASPUButtonActionsListViewModel: ASPUButtonActionsListViewModelProtocol {
    
    func actionItem(index: Int) -> ASPUButtonActions {
        let action = ASPUButtonActions.allCases[index]
        return action
    }
    
    func actionItemsCount() -> Int {
        return ASPUButtonActions.allCases.count
    }
    
    func selectAction(index: Int) {
        let savedAction = UserDefaults.loadData(type: ASPUButtonActions.self, key: "action") ?? .speechRecognition
        let action = actionItem(index: index)
        if savedAction != action {
            UserDefaults.saveData(object: action, key: "action") {
                NotificationCenter.default.post(name: Notification.Name("action"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.dataSelectedHandler?()
            }
        }
    }
    
    func isActionSelected(index: Int) -> Bool {
        let savedAction = UserDefaults.loadData(type: ASPUButtonActions.self, key: "action") ?? .speechRecognition
        let action = actionItem(index: index)
        if savedAction == action {
            return true
        }
        return false
    }
    
    func registerDataSelectedHandler(block: @escaping()->Void) {
        self.dataSelectedHandler = block
    }
}
