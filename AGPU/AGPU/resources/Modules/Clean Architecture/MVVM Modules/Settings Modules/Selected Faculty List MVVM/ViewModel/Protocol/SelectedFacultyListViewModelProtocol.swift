//
//  SelectedFacultyListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import Foundation

protocol SelectedFacultyListViewModelProtocol {
    
    func facultiesListCount()-> Int
    func facultyItem(index: Int)-> AGPUFacultyModel
    func chooseFaculty(index: Int)
    func chooseFacultyIcon(index: Int)
    func cancelFacultyIcon(index: Int)
    func cancelFaculty(index: Int)
    func isFacultySelected(index: Int)-> Bool
    func isFacultyIconSelected(index: Int)-> Bool
    func isCathedraSelected(index: Int)-> Bool
    func isGroupSelected(index: Int)-> Bool
    func isSubGroupSelected(index: Int)-> Bool
}
