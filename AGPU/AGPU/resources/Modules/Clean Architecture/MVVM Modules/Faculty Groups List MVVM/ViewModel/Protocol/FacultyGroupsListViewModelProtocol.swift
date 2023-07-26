//
//  FacultyGroupsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

protocol FacultyGroupsListViewModelProtocol {
    func GetGroups(by faculty: AGPUFacultyModel)
    func groupsListCount(section: Int)-> Int
    func groupItem(section: Int, index: Int)-> String
    func SelectGroup(section: Int, index: Int)
    func isGroupSelected(section: Int, index: Int)-> Bool
    func isGroupSelectedColor(section: Int, index: Int)-> UIColor
}
