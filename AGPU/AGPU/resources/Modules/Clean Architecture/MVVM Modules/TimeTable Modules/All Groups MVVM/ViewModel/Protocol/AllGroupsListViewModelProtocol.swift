//
//  AllGroupsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit

protocol AllGroupsListViewModelProtocol {
    func numberOfGroupSections()-> Int
    func groupSectionItem(section: Int)-> FacultyGroupModel
    func groupItem(section: Int, index: Int)-> String
    func selectGroup(section: Int, index: Int)
    func isGroupSelected(section: Int, index: Int)-> Bool
    func scrollToSelectedGroup()
    func currentFacultyIcon(section: Int, abbreviation: String)-> String
    func makeGroupsMenu()-> UIMenu
    func registerDataChangedHandler(block: @escaping()->Void)
    func registerScrollHandler(block: @escaping(Int, Int)->Void)
    func registerGroupSelectedHandler(block: @escaping()->Void)
}
