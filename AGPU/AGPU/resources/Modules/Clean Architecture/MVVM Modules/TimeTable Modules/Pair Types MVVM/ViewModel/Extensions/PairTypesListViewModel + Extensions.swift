//
//  PairTypesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2023.
//

import Foundation

// MARK: - PairTypesListViewModelProtocol
extension PairTypesListViewModel: PairTypesListViewModelProtocol {
    
    func registerPairTypeSelectedHandler(block: @escaping(()->Void)) {
        self.pairTypeSelectedHandler = block
    }
    
    func typeItem(index: Int)-> PairTypeModel {
        return PairTypesList.list[index]
    }
    
    func numberOfTypesInSection()-> Int {
        return PairTypesList.list.count
    }
    
    func choosePairType(index: Int) {
        let type = PairTypesList.list[index]
        NotificationCenter.default.post(name: Notification.Name("TypeWasSelected"), object: type.type)
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
}
