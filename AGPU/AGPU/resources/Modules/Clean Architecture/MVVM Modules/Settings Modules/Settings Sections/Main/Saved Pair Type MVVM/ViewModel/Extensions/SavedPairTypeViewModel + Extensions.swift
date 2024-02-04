//
//  SavedPairTypeViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import Foundation

// MARK: - SavedPairTypeViewModelProtocol
extension SavedPairTypeViewModel: SavedPairTypeViewModelProtocol {
    
    func typeItem(index: Int)-> PairType {
        return PairType.allCases[index]
    }
    
    func numberOfTypesInSection()-> Int {
        return PairType.allCases.count
    }
    
    func choosePairType(index: Int) {
        let type = typeItem(index: index)
        UserDefaults.saveData(object: type, key: "type") {
            NotificationCenter.default.post(name: Notification.Name("TypeWasSelected"), object: type)
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
            print("тип пары сохранен")
        }
        self.type = type
        self.pairTypeSelectedHandler?()
        HapticsManager.shared.hapticFeedback()
    }
    
    func isCurrentType(index: Int)-> Bool {
        let type = typeItem(index: index)
        if type == self.type {
            return true
        } else {
            return false
        }
    }
    
    func registerPairTypeSelectedHandler(block: @escaping(()->Void)) {
        self.pairTypeSelectedHandler = block
    }
}
