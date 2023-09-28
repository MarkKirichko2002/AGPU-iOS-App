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
    
    func subgroupItem(index: Int)-> SubGroupModel {
        let subgroup = SubGroupsList.subgroups[index]
        return subgroup
    }
    
    func selectSubGroup(index: Int) {
        let subgroupItem = SubGroupsList.subgroups[index]
        NotificationCenter.default.post(name: Notification.Name("subgroup changed"), object: subgroupItem.number)
        subgroup = subgroupItem.number
        changedHandler?()
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
    
    func registerChangedHandler(block: @escaping()->Void) {
        self.changedHandler = block
    }
}
