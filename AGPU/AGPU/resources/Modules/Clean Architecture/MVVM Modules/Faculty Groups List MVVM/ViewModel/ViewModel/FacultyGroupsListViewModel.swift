//
//  FacultyGroupsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.07.2023.
//

import UIKit

final class FacultyGroupsListViewModel: NSObject {
    
    @objc dynamic var isChanged = false
    var observation: NSKeyValueObservation?
    
    var groups = [FacultyGroupModel]()
    
    // MARK: - сервисы
    let timetableService = TimeTableService()
    
}
