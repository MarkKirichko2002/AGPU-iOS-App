//
//  PairTypesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2023.
//

import Foundation

// MARK: - PairTypesListViewModelProtocol
extension PairTypesListViewModel: PairTypesListViewModelProtocol {
    
    func typeItem(index: Int)-> PairType {
        return PairType.allCases[index]
    }
    
    func numberOfTypesInSection()-> Int {
        return PairType.allCases.count
    }
    
    func countForPairType(index: Int)-> Int {
        let type = typeItem(index: index)
        var filteredData = [Discipline]()
        var uniqueTimes: Set<String> = Set()
        
        if type != .all {
            filteredData = disciplines.filter({ $0.type == type })
        } else {
            filteredData = disciplines
        }
        
        for pair in filteredData {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
        
    }
    
    func choosePairType(index: Int) {
        let type = typeItem(index: index)
        NotificationCenter.default.post(name: Notification.Name("TypeWasSelected"), object: type)
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
