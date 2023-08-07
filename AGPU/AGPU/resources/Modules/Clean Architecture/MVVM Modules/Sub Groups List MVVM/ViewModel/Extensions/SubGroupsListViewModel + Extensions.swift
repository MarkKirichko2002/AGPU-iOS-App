//
//  SubGroupsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

// MARK: - SubGroupsListViewModelProtocol
extension SubGroupsListViewModel: SubGroupsListViewModelProtocol {
    
    func selectSubGroup(index: Int) {
        let subgroup = [1,2]
        UserDefaults.standard.setValue(subgroup[index], forKey: "subgroup")
        NotificationCenter.default.post(name: Notification.Name("subgroup changed"), object: nil)
        changedHandler?()
    }
    
    func isSubGroupSelected(index: Int)-> Bool {
        let subgroup = [1,2]
        let lastSubGroup = UserDefaults.standard.integer(forKey: "subgroup")
        if lastSubGroup == subgroup[index] {
            return true
        } else {
            return false
        }
    }
}
