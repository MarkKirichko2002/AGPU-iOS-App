//
//  TimetableMenuWeekDaysListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.07.2025.
//

import Foundation

final class TimetableMenuWeekDaysListViewModel {
    
    var id: String = ""
    var currentDate: String = ""
    var owner: String = ""
    var week: WeekModel
    
    var days = DaysList.days
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let timetableService = TimeTableService()
    let dateManager = DateManager()
    let settingsManager = SettingsManager()
    
    // MARK: - Init
    init(id: String, currentDate: String, owner: String, week: WeekModel) {
        self.id = id
        self.currentDate = currentDate
        self.owner = owner
        self.week = week
    }
}
