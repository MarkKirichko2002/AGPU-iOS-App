//
//  SettingsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import UIKit

class SettingsListViewModel: NSObject {
    
    @objc dynamic var isChanged = false
    
    var observation: NSKeyValueObservation?
    
    func groupsListCount()-> Int {
        return AGPUGroups.groups.count
    }
    
    func groupItem(index: Int)-> String {
        return AGPUGroups.groups[index]
    }
    
    func ChangeGroup(index: Int) {
        let group = AGPUGroups.groups[index]
        UserDefaults.standard.setValue(group, forKey: "group")
        self.isChanged.toggle()
    }
    
    func isGroupSelected(index: Int)-> UITableViewCell.AccessoryType {
        let group = UserDefaults.standard.object(forKey: "group") as? String ?? ""
        if group == AGPUGroups.groups[index] {
            return .checkmark
        } else {
            return .none
        }
    }
}
