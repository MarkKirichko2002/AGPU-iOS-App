//
//  ISelectedFacultySplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 09.03.2024.
//

import Foundation

protocol ISelectedFacultySplashScreenViewModel {
    func getFaculty()
    func registerFacultyHandler(block: @escaping(AGPUFacultyModel)->Void)
}
