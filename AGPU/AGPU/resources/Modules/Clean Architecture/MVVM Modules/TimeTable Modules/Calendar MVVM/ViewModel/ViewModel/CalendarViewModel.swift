//
//  CalendarViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import Foundation

class CalendarViewModel {
    
    var date: String = ""
    var group: String = ""
    var dateSelectedHandler: (()->Void)?
    
    var noTimetableHandler: (()->Void)?
    var timetableHandler: (()->Void)?
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let service = TimeTableService()
    
    // MARK: - Init
    init(group: String) {
        self.group = group
    }
}
