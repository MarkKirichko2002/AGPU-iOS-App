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
        return groups.count
    }
    
    func groupSectionItem(section: Int)-> FacultyGroupModel {
        return groups[section]
    }
    
    func groupItem(section: Int, index: Int)-> String {
        return groupSectionItem(section: section).groups[index]
    }
    
    func getGroups() {
        service.getGroups { result in
            switch result {
            case .success(let data):
                self.groups = data
                self.isLoading.toggle()
                self.dataChangedHandler?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func selectGroup(section: Int, index: Int) {
        let group = groupItem(section: section, index: index)
        if group != self.group {
            self.group = group
            self.groupSelectedHandler?()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func isGroupSelected(section: Int, index: Int)-> Bool {
        let group = groups[section].groups[index]
        let lastGroup = self.group
        if lastGroup == group {
            return true
        } else {
            return false
        }
    }
    
    func scrollToSelectedGroup() {
        if !groups.isEmpty {
            for (groupIndex, groupItems) in groups.enumerated() {
                for (elementIndex, group) in groupItems.groups.enumerated() {
                    if group == self.group {
                        if !self.isLoading {
                            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                self.scrollHandler?(groupIndex, elementIndex)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func currentFacultyIcon(section: Int, abbreviation: String)-> String {
        let group = groups[section]
        for faculty in AGPUFaculties.faculties {
            if group.facultyName.abbreviation().contains(faculty.abbreviation) {
                return faculty.icon
            }
        }
        return "АГПУ"
    }
    
    func makeGroupsMenu()-> UIMenu {
        
        var currentGroup = ""
        
        if let group = groups.first(where: { $0.groups.contains(self.group)}) {
            currentGroup = group.facultyName
        }
        
        let items = groups.enumerated().map { (index: Int, group: FacultyGroupModel) in
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
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerScrollHandler(block: @escaping(Int, Int)->Void) {
        self.scrollHandler = block
    }
    
    func registerGroupSelectedHandler(block: @escaping()->Void) {
        self.groupSelectedHandler = block
    }
}
