//
//  AllGroupsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit

protocol AllGroupsListViewModelProtocol {
    func registerGroupSelectedHandler(block: @escaping()->Void)
    func groupSectionItem(section: Int)-> FacultyGroupModel
    func groupItem(section: Int, index: Int)-> String
    func SelectGroup(section: Int, index: Int)
    func isGroupSelected(section: Int, index: Int)-> Bool
    func scrollToSelectedGroup(completion: @escaping(Int, Int)->Void)
    func currentFacultyIcon(section: Int, abbreviation: String)-> String
    func makeGroupsMenu()-> UIMenu
}
