//
//  FacultyCathedraMapListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import Foundation

final class FacultyCathedraMapListViewModel {
    
    var faculty: AGPUFacultyModel?
    var dataChangedHandler: (()->Void)?
    var facultySelectedHandler: (()->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    // MARK: - Init
    init(faculty: AGPUFacultyModel?) {
        self.faculty = faculty
    }
}
