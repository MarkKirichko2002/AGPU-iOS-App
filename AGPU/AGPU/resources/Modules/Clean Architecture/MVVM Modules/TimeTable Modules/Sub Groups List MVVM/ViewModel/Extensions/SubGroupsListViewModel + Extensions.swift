//
//  SubGroupsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 28.09.2023.
//

import Foundation

// MARK: - SubGroupsListViewModelProtocol
extension SubGroupsListViewModel: SubGroupsListViewModelProtocol {
    
    func numberOfSubGroups()-> Int {
        return SubGroupsList.subgroups.count
    }
    
    func subGroupNumber(index: Int)-> Int {
        return SubGroupsList.subgroups[index].number
    }
    
    func subgroupItem(index: Int)-> String {
        let subgroup = SubGroupsList.subgroups[index]
        return "\(subgroup.name) (пар: \(subgroup.pairsCount))"
    }
    
    func getPairsCount(pairs: [Discipline]) {
        
        var firstSubGroupDisciplines: Set<String> = Set()
        var secondSubGroupDisciplines: Set<String> = Set()
        var noSubGroupDisciplines: Set<String> = Set()
        
        let firstSubGroupDisciplinesArr = pairs.filter { $0.subgroup == 1}
        let secondSubGroupDisciplinesArr = pairs.filter { $0.subgroup == 2}
        let noSubGroupDisciplinesArr = pairs.filter { $0.subgroup == 0}
        
        for pair in firstSubGroupDisciplinesArr {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            firstSubGroupDisciplines.insert(startTime)
        }
        
        for pair in secondSubGroupDisciplinesArr {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            secondSubGroupDisciplines.insert(startTime)
        }
        
        for pair in noSubGroupDisciplinesArr {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            noSubGroupDisciplines.insert(startTime)
        }
        
        SubGroupsList.subgroups[0].pairsCount = firstSubGroupDisciplines.count
        SubGroupsList.subgroups[1].pairsCount = secondSubGroupDisciplines.count
        SubGroupsList.subgroups[2].pairsCount = noSubGroupDisciplines.count
        
        dataChangedHandler?()
    }
    
    func selectSubGroup(index: Int) {
        let subgroupItem = SubGroupsList.subgroups[index]
        subgroup = subgroupItem.number
        subGroupSelectedHandler?()
        HapticsManager.shared.hapticFeedback()
    }
    
    func isSubGroupSelected(index: Int)-> Bool {
        let subgroupItem = SubGroupsList.subgroups[index]
        if subgroupItem.number == subgroup {
            return true
        } else {
            return false
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerSubGroupSelectedHandler(block: @escaping()->Void) {
        self.subGroupSelectedHandler = block
    }
}
