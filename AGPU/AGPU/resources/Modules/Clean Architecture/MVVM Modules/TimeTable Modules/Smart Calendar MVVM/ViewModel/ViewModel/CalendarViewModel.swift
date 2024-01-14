//
//  CalendarViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import UIKit

class CalendarViewModel {
    
    var id: String = ""
    var date: String = ""
    var owner: String = ""
    
    var timetableHandler: ((String, String, UIColor)->Void)?
    var dateSelectedHandler: (()->Void)?
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let service = TimeTableService()
    
    // MARK: - Init
    init(id: String, owner: String) {
        self.id = id
        self.owner = owner
    }
}
