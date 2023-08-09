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
        let lastGroup = self.group
        if lastGroup == group {
            return true
        } else {
            return false
        }
    }
    
    func scrollToSelectedGroup(completion: @escaping(Int, Int)->Void) {
        for (groupIndex, groups) in FacultyGroups.groups.enumerated() {
            for (elementIndex, group) in groups.groups.enumerated() {
                if group == self.group {
                    completion(groupIndex, elementIndex)
                }
            }
        }
    }
    
    func currentFacultyIcon(section: Int, abbreviation: String)-> String {
        let group = FacultyGroups.groups[section]
        for faculty in AGPUFaculties.faculties {
            if group.name.abbreviation().contains(faculty.abbreviation) {
                return faculty.icon
            }
        }
        return "АГПУ"
    }
}
