//
//  FacultyCathedraListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import Foundation

final class FacultyCathedraListViewModel: NSObject {
    
    @objc dynamic var isChanged = false
    var observation: NSKeyValueObservation?
    var faculty: AGPUFacultyModel
    
    // MARK: - Init
    init(faculty: AGPUFacultyModel) {
        self.faculty = faculty
    }
    
}
