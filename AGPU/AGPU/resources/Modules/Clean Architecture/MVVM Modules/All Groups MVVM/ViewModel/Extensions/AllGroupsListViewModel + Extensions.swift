//
//  AllGroupsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit

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
    
    func makeGroupsMenu()-> UIMenu {
        
        var currentGroup = ""
        
        if let group = FacultyGroups.groups.first(where: { $0.groups.contains(self.group)}) {
            print("Группа \(self.group) находится в группе \(group.name)")
            currentGroup = group.name
        } else {
            print("Группа \(self.group) не найдена")
        }
        
        let items = FacultyGroups.groups.enumerated().map { (index: Int, group: FacultyGroupModel) in
            let groupItem = group.name
            let actionHandler: UIActionHandler = { [weak self] _ in
                DispatchQueue.main.async {
                    self?.scrollHandler?(index, 0)
                }
            }
            return UIAction(title: group.name.abbreviation(), state: currentGroup == groupItem ? .on : .off, handler: actionHandler)
        }
        let menu = UIMenu(title: "группы", options: .singleSelection, children: items)
        return menu
    }
}
