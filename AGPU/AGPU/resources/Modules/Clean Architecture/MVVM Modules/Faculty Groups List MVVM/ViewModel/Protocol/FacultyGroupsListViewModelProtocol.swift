//
//  FacultyGroupsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

protocol FacultyGroupsListViewModelProtocol {
    func getGroups(by faculty: AGPUFacultyModel)
    func groupsListCount(section: Int)-> Int
    func groupItem(section: Int, index: Int)-> String
    func selectGroup(section: Int, index: Int)
    func isGroupSelected(section: Int, index: Int)-> Bool
    func makeGroupsMenu()-> UIMenu
    func scrollToSelectedGroup()
    func registerScrollHandler(block: @escaping(Int, Int)->Void)
}
