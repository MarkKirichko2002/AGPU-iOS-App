//
//  FacultyCathedraMapListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import Foundation

protocol FacultyCathedraMapListViewModelProtocol {
    func facultyItem(index: Int)-> AGPUFacultyModel
    func numberOfFacultiesInSection()-> Int
    func chooseFaculty(index: Int)
    func isCurrentFaculty(index: Int)-> Bool
    func registerFacultySelectedHandler(block: @escaping(()->Void))
    func registerDataChangedHandler(block: @escaping()->Void)
}
