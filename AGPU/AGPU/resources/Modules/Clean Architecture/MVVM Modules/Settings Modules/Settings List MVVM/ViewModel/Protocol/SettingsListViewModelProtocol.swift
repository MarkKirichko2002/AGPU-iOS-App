//
//  SettingsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import Foundation

protocol SettingsListViewModelProtocol {
    func sectionsCount()-> Int
    func statusListCount()-> Int
    func chooseStatus(index: Int)
    func isStatusSelected(index: Int)-> Bool
    func facultiesListCount()-> Int
    func facultyItem(index: Int)-> AGPUFacultyModel
    func chooseFaculty(index: Int)
    func cancelFaculty(index: Int)
    func isFacultySelected(index: Int)-> Bool
    func isCathedraSelected(index: Int)-> Bool
    func isGroupSelected(index: Int)-> Bool
    func isSubGroupSelected(index: Int)-> Bool
}
