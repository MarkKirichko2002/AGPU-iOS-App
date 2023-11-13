//
//  AllGroupsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit

// MARK: - AllGroupsListViewModelProtocol
extension AllGroupsListViewModel: AllGroupsListViewModelProtocol {
    
    func numberOfGroupSections()-> Int {
        return FacultyGroups.groups.count
    }
    
    func groupSectionItem(section: Int)-> FacultyGroupModel {
        return FacultyGroups.groups[section]
    }
    
    func groupItem(section: Int, index: Int)-> String {
        return groupSectionItem(section: section).groups[index]
    }
    
    func selectGroup(section: Int, index: Int) {
        let group = groupItem(section: section, index: index)
        if group != self.group {
            NotificationCenter.default.post(name: Notification.Name("group changed"), object: group)
            self.group = group
            self.groupSelectedHandler?()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func registerGroupSelectedHandler(block: @escaping()->Void) {
        self.groupSelectedHandler = block
    }
    
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
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        completion(groupIndex, elementIndex)
                    }
                }
            }
        }
    }
    
    func currentFacultyIcon(section: Int, abbreviation: String)-> String {
        let group = FacultyGroups.groups[section]
        for faculty in AGPUFaculties.faculties {
            if group.facultyName.abbreviation().contains(faculty.abbreviation) {
                return faculty.icon
            }
        }
        return "АГПУ"
    }
    
    func makeGroupsMenu()-> UIMenu {
        
        var currentGroup = ""
        
        if let group = FacultyGroups.groups.first(where: { $0.groups.contains(self.group)}) {
            currentGroup = group.facultyName
        }
        
        let items = FacultyGroups.groups.enumerated().map { (index: Int, group: FacultyGroupModel) in
            let groupItem = group.facultyName
            let actionHandler: UIActionHandler = { [weak self] _ in
                DispatchQueue.main.async {
                    self?.scrollHandler?(index, 0)
                }
            }
            return UIAction(title: group.facultyName.abbreviation(), state: currentGroup == groupItem ? .on : .off, handler: actionHandler)
        }
        let menu = UIMenu(title: "Группы", options: .singleSelection, children: items)
        return menu
    }
}
