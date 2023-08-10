//
//  AllGroupsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit

protocol AllGroupsListViewModelProtocol {
    func isGroupSelected(section: Int, index: Int)-> Bool
    func scrollToSelectedGroup(completion: @escaping(Int, Int)->Void)
    func currentFacultyIcon(section: Int, abbreviation: String)-> String
    func makeGroupsMenu()-> UIMenu
}
