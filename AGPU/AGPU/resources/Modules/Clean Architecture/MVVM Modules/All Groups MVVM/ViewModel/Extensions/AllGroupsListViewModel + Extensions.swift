//
//  AllGroupsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import Foundation

// MARK: - AllGroupsListViewModelProtocol
extension AllGroupsListViewModel: AllGroupsListViewModelProtocol {
    
    func isGroupSelected(section: Int, index: Int)-> Bool {
        let group = FacultyGroups.groups[section].groups[index]
        let lastGroup = UserDefaults.standard.string(forKey: "selected group")
        if lastGroup == group {
            return true
        } else {
            return false
        }
    }
}
