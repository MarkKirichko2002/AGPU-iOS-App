//
//  FacultyCathedraMapListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import Foundation

// MARK: - FacultyCathedraMapListViewModelProtocol
extension FacultyCathedraMapListViewModel: FacultyCathedraMapListViewModelProtocol {
    
    func facultyItem(index: Int)-> AGPUFacultyModel {
        let faculty = AGPUFaculties.faculties[index]
        return faculty
    }
    
    func numberOfFaculties()-> Int {
        let count = AGPUFaculties.faculties.count
        return count
    }
    
    func titleForNavigation()-> String {
        let style = settingsManager.getSavedCommunicationStyle()
        return style == .formal ? "Выберите факультет" : "Выбери факультет"
    }
}
