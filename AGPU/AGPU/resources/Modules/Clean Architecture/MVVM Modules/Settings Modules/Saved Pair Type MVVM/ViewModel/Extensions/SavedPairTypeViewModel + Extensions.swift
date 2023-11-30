//
//  SavedPairTypeViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import Foundation

// MARK: - SavedPairTypeViewModelProtocol
extension SavedPairTypeViewModel: SavedPairTypeViewModelProtocol {
    
    func typeItem(index: Int)-> PairTypeModel {
        return PairTypesList.list[index]
    }
    
    func numberOfTypesInSection()-> Int {
        return PairTypesList.list.count
    }
    
    func choosePairType(index: Int) {
        let type = PairTypesList.list[index]
        UserDefaults.saveData(object: type.type, key: "type") {
            NotificationCenter.default.post(name: Notification.Name("TypeWasSelected"), object: type.type)
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
            print("тип пары сохранен")
        }
        self.type = type.type
        self.pairTypeSelectedHandler?()
        HapticsManager.shared.hapticFeedback()
    }
    
    func isCurrentType(index: Int)-> Bool {
        let type = PairTypesList.list[index]
        if type.type == self.type {
            return true
        } else {
            return false
        }
    }
    
    func registerPairTypeSelectedHandler(block: @escaping(()->Void)) {
        self.pairTypeSelectedHandler = block
    }
}
