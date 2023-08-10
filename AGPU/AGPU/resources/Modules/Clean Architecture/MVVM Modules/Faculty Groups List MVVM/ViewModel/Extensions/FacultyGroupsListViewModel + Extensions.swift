//
//  FacultyGroupsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

// MARK: - FacultyGroupsListViewModelProtocol
extension FacultyGroupsListViewModel: FacultyGroupsListViewModelProtocol {
    
    func GetGroups(by faculty: AGPUFacultyModel) {
        for group in FacultyGroups.groups {
            if group.name.abbreviation().contains(faculty.abbreviation) {
                self.groups.append(group)
                self.isChanged.toggle()
            }
        }
    }
    
    // MARK: - Elected Faculty
    func groupsListCount(section: Int)-> Int {
        return groups.count
    }
    
    func groupItem(section: Int, index: Int)-> String {
        return groups[section].groups[index]
    }
    
    func SelectGroup(section: Int, index: Int) {
        let group = groupItem(section: section, index: index)
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            if groups[section].name.abbreviation().contains(faculty.abbreviation) {
                UserDefaults.standard.setValue(group, forKey: "group")
                self.isChanged.toggle()
                NotificationCenter.default.post(name: Notification.Name("group changed"), object: group)
            } else {
                print("no \(groups[section].name) != \(faculty.abbreviation)")
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
    
    func scrollToSelectedGroup(completion: @escaping(Int, Int)->Void) {
        let savedGroup = UserDefaults.standard.object(forKey: "group") as? String ?? ""
        for (sectionIndex, groupsSections) in self.groups.enumerated() {
            for (itemIndex, groupItem) in groupsSections.groups.enumerated() {
                print(groupItem)
                if groupItem == savedGroup {
                    completion(sectionIndex, itemIndex)
                }
            }
        }
    }
}
