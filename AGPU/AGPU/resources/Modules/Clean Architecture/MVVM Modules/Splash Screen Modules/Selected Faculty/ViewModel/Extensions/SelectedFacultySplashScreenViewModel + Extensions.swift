//
//  SelectedFacultySplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 09.03.2024.
//

import Foundation

// MARK: - ISelectedFacultySplashScreenViewModel
extension SelectedFacultySplashScreenViewModel: ISelectedFacultySplashScreenViewModel {
    
    func getFaculty() {
        if let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            self.facultyHandler?(faculty)
        } else {
            self.facultyHandler?(nil)
        }
    }
    
    func registerFacultyHandler(block: @escaping(AGPUFacultyModel?)->Void) {
        self.facultyHandler = block
    }
}
