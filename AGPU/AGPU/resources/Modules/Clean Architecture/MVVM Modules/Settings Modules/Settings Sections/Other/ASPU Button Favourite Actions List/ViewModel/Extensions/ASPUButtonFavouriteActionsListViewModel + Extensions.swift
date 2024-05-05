//
//  ASPUButtonFavouriteActionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import Foundation

// MARK: - IASPUButtonFavouriteActionsListViewModel
extension ASPUButtonFavouriteActionsListViewModel: IASPUButtonFavouriteActionsListViewModel {
    
    func actionsCount()-> Int {
        return actions.count
    }
    
    func actionItem(index: Int)-> ASPUButtonActions {
        let action = actions[index]
        return action
    }
    
    func getActions() {
        actions = loadActions()
        dataChangedHandler?()
    }
    
    func updateActions(actions: [ASPUButtonActions], _ index: Int, _ index2: Int) {
        
        var arr = [ASPUButtonActions]()
        
        for action in actions {
            arr.append(action)
        }
        
        print("\(index) and \(index2)")
        
        arr.swapAt(index, index2)
        
        saveArray(array: arr)
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
     
    func deleteAction(action: ASPUButtonActions) {
        
        var actions = loadActions()
        
        if let index = actions.firstIndex(where: { $0 == action }) {
            actions.remove(at: index)
        }
        HapticsManager.shared.hapticFeedback()
        saveArray(array: actions)
    }
    
    func saveArray(array: [ASPUButtonActions]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: "button actions")
            getActions()
        } catch {
            print(error)
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}