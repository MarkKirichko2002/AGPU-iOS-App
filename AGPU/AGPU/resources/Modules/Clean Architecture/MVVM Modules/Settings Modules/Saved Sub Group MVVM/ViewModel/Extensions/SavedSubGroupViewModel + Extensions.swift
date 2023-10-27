//
//  SavedSubGroupViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

// MARK: - SavedSubGroupViewModelProtocol
extension SavedSubGroupViewModel: SavedSubGroupViewModelProtocol {
    
    func numberOfSubGroups()-> Int {
        return SubGroupsList.subgroups.count
    }
    
    func subgroupItem(index: Int)-> SubGroupModel {
        let subgroup = SubGroupsList.subgroups[index]
        return subgroup
    }
    
    func selectSubGroup(index: Int) {
        let lastSubGroup = UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
        let subgroup = subgroupItem(index: index).number
        if subgroup != lastSubGroup {
            UserDefaults.standard.setValue(subgroup, forKey: "subgroup")
            NotificationCenter.default.post(name: Notification.Name("subgroup changed"), object: subgroup)
            changedHandler?()
            HapticsManager.shared.hapticFeedback()
        } else {
            print("подгруппа уже выбрана")
        }
    }
    
    func isSubGroupSelected(index: Int)-> Bool {
        let lastSubGroup = UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
        let subgroup = SubGroupsList.subgroups[index]
        print(lastSubGroup)
        if lastSubGroup == subgroup.number {
            return true
        } else {
            return false
        }
    }
    
    func registerChangedHandler(block: @escaping()->Void) {
        self.changedHandler = block
    }
}
