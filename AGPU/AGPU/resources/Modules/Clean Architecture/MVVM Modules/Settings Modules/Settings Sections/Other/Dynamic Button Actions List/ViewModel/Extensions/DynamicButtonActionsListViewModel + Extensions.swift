//
//  DynamicButtonActionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import Foundation

// MARK: - DynamicButtonActionsListViewModelProtocol
extension DynamicButtonActionsListViewModel: DynamicButtonActionsListViewModelProtocol {
    
    func actionItem(index: Int) -> DynamicButtonActions {
        let action = DynamicButtonActions.allCases[index]
        return action
    }
    
    func actionItemsCount() -> Int {
        return DynamicButtonActions.allCases.count
    }
    
    func selectAction(index: Int) {
        let savedAction = UserDefaults.loadData(type: DynamicButtonActions.self, key: "action") ?? .speechRecognition
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
        let savedAction = UserDefaults.loadData(type: DynamicButtonActions.self, key: "action") ?? .speechRecognition
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
