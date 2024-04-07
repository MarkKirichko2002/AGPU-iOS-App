//
//  WeekDaysListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 17.03.2024.
//

import Foundation

class WeekDaysListViewModel {
    
    var id: String
    var owner: String
    var week: WeekModel
    var timetable = [TimeTable]()
    
    var days = [DayModel]()
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let service = TimeTableService()
    
    // MARK: - Init
    init(id: String, owner: String, week: WeekModel, timetable: [TimeTable]) {
        self.id = id
        self.owner = owner
        self.week = week
        self.timetable = timetable
    }
}
