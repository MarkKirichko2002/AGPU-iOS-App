//
//  FacultyCathedraMapListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import Foundation

protocol FacultyCathedraMapListViewModelProtocol {
    func facultyItem(index: Int)-> AGPUFacultyModel
    func numberOfFaculties()-> Int
    func titleForNavigation()-> String
}
