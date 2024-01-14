//
//  DaysListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import Foundation

class DaysListViewModel {
    
    var id: String = ""
    var currentDate: String = ""
    var owner: String = ""
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let timetableService = TimeTableService()
    let dateManager = DateManager()
    
    // MARK: - Init
    init(id: String, currentDate: String, owner: String) {
        self.id = id
        self.currentDate = currentDate
        self.owner = owner
    }
}
