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
        timetableService.GetAllGroups { groups in
            for (key, value) in groups {
                if key.abbreviation().contains(faculty.abbreviation) {
                    self.groups[key.abbreviation()] = value
                    self.key = key
                    self.isChanged.toggle()
                }
            }
        }
    }
    
    // MARK: - Elected Faculty
    func groupsListCount(section: Int)-> Int {
        return Array(groups.values)[section].count
    }
    
    func groupItem(section: Int, index: Int)-> String {
        return Array(groups.values)[section][index]
    }
    
    func SelectGroup(section: Int, index: Int) {
        let group = groupItem(section: section, index: index)
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            if key.abbreviation().contains(faculty.abbreviation) {
                UserDefaults.standard.setValue(group, forKey: "group")
                self.isChanged.toggle()
            } else {
                print("no \(key.abbreviation()) != \(faculty.abbreviation)")
            }
        }
    }
    
    func isGroupSelected(section: Int, index: Int)-> UITableViewCell.AccessoryType {
        let group = UserDefaults.standard.object(forKey: "group") as? String ?? ""
        if group == groupItem(section: section, index: index) {
            return .checkmark
        } else {
            return .none
        }
    }
}
