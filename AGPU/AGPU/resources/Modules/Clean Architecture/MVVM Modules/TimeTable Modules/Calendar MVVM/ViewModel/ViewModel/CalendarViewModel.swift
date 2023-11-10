//
//  CalendarViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import UIKit

class CalendarViewModel {
    
    var date: String = ""
    var group: String = ""
    
    var timetableHandler: ((String, String, UIColor)->Void)?
    var dateSelectedHandler: (()->Void)?
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let service = TimeTableService()
    
    // MARK: - Init
    init(group: String) {
        self.group = group
    }
}
