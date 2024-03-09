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
    
    func numberOfFacultiesInSection()-> Int {
        let count = AGPUFaculties.faculties.count
        return count
    }
    
    func chooseFaculty(index: Int) {
        let selectedFaculty = AGPUFaculties.faculties[index]
        if faculty?.id != selectedFaculty.id {
            NotificationCenter.default.post(name: Notification.Name("faculty selected"), object: selectedFaculty)
            faculty = selectedFaculty
            self.dataChangedHandler?()
            self.facultySelectedHandler?()
            HapticsManager.shared.hapticFeedback()
        } else {}
    }
    
    func isCurrentFaculty(index: Int)-> Bool {
        let currentFaculty = AGPUFaculties.faculties[index]
        if currentFaculty.id == faculty?.id {
            return true
        } else {
            return false
        }
    }
    
    func registerFacultySelectedHandler(block: @escaping(()->Void)) {
        self.facultySelectedHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
