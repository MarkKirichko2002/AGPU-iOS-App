//
//  DaysListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import Foundation

class DaysListViewModel {
    
    var group: String = ""
    var currentDate: String = ""
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let timetableService = TimeTableService()
    let dateManager = DateManager()
    
    // MARK: - Init
    init(group: String, currentDate: String) {
        self.group = group
        self.currentDate = currentDate
    }
}
