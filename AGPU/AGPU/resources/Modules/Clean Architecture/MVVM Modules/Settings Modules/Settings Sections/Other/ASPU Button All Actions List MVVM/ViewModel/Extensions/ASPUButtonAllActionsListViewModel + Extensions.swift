//
//  ASPUButtonAllActionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import Foundation

// MARK: - ASPUButtonAllActionsListViewModel
extension ASPUButtonAllActionsListViewModel: IASPUButtonAllActionsListViewModel {
    
    func actionsCount()-> Int {
        return ASPUButtonActions.allCases.count - 1
    }
    
    func actionItem(index: Int)-> ASPUButtonActions {
        let item = ASPUButtonActions.allCases[index]
        return item
    }
    
    func selectAction(index: Int) {
        let action = actionItem(index: index)
        saveAction(action: action)
    }
    
    func saveAction(action: ASPUButtonActions) {
        var actions = loadActions()
        if !actions.contains(action) {
            HapticsManager.shared.hapticFeedback()
            actions.append(action)
        }
        saveArray(array: actions)
    }
    
    func saveActions(actions: [ASPUButtonActions]) {
        var savedActions = loadActions()
        for action in actions {
            if !savedActions.contains(action) {
                savedActions.append(action)
            }
        }
        saveArray(array: savedActions)
    }
    
    func loadActions()-> [ASPUButtonActions] {
        var data = [ASPUButtonActions]()
        if let result = UserDefaults.standard.object(forKey: "button actions") as? Data {
            do {
                data = try JSONDecoder().decode([ASPUButtonActions].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func saveArray(array: [ASPUButtonActions]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: "button actions")
        } catch {
            print(error)
        }
        itemSelectedHandler?()
    }
    
    func registerItemSelectedHandler(block: @escaping()->Void) {
        self.itemSelectedHandler = block
    }
}
