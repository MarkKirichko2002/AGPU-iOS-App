//
//  FacultyGroupsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

// MARK: - FacultyGroupsListViewModelProtocol
extension FacultyGroupsListViewModel: FacultyGroupsListViewModelProtocol {
    
    func getGroups(by faculty: AGPUFacultyModel) {
        for group in FacultyGroups.groups {
            if group.facultyName.abbreviation().contains(faculty.abbreviation) {
                self.groups.append(group)
                self.isChanged.toggle()
            }
        }
    }
    
    // MARK: - Selected Faculty
    func groupsListCount(section: Int)-> Int {
        return groups.count
    }
    
    func groupItem(section: Int, index: Int)-> String {
        return groups[section].groups[index]
    }
    
    func selectGroup(section: Int, index: Int) {
        let group = groupItem(section: section, index: index)
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            if groups[section].facultyName.abbreviation().contains(faculty.abbreviation) {
                UserDefaults.standard.setValue(group, forKey: "group")
                self.isChanged.toggle()
                HapticsManager.shared.hapticFeedback()
                NotificationCenter.default.post(name: Notification.Name("group changed"), object: group)
            } else {
                print("no \(groups[section].facultyName) != \(faculty.abbreviation)")
            }
        }
    }
    
    func isGroupSelected(section: Int, index: Int)-> Bool {
        let group = UserDefaults.standard.object(forKey: "group") as? String ?? ""
        if group == groupItem(section: section, index: index) {
            return true
        } else {
            return false
        }
    }
    
    func makeGroupsMenu()-> UIMenu {
        
        let savedGroup = UserDefaults.standard.object(forKey: "group") as? String ?? ""
        
        var currentGroup = ""
        
        if let group = self.groups.first(where: { $0.groups.contains(savedGroup)}) {
            currentGroup = group.facultyName
        }
        
        let items = self.groups.enumerated().map { (section: Int, group: FacultyGroupModel) in
            let actionHandler: UIActionHandler = { [weak self] _ in
                DispatchQueue.main.async {
                    self?.scrollHandler?(section, 0)
                }
            }
            return UIAction(title: group.facultyName.abbreviation(), state: currentGroup == group.facultyName ? .on : .off, handler: actionHandler)
        }
        let menu = UIMenu(title: "группы", options: .singleSelection, children: items)
        return menu
    }
    
    func scrollToSelectedGroup() {
        let savedGroup = UserDefaults.standard.object(forKey: "group") as? String ?? ""
        for (sectionIndex, groupsSections) in self.groups.enumerated() {
            for (itemIndex, groupItem) in groupsSections.groups.enumerated() {
                print(groupItem)
                if groupItem == savedGroup {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        self.scrollHandler?(sectionIndex, itemIndex)
                    }
                }
            }
        }
    }
    
    func registerScrollHandler(block: @escaping (Int, Int) -> Void) {
        self.scrollHandler = block
    }
}
