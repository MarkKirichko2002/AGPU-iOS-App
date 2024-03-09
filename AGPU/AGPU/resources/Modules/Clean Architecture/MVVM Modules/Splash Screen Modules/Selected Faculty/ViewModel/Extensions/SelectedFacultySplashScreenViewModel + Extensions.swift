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
        guard let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") else {return}
        self.facultyHandler?(faculty)
    }
    
    func registerFacultyHandler(block: @escaping(AGPUFacultyModel)->Void) {
        self.facultyHandler = block
    }
}
