//
//  AllGroupsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import Foundation

protocol AllGroupsListViewModelProtocol {
    func isGroupSelected(section: Int, index: Int)-> Bool
    func currentFacultyIcon(section: Int, abbreviation: String)-> String
}
