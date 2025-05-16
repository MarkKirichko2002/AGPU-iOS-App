//
//  DaysListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import Foundation

final class DaysListViewModel {
    
    var id: String = ""
    var currentDate: String = ""
    var owner: String = ""
    var dayType: DayType
    var week: WeekModel
    var dates: [String]
    
    var days = DaysList.days
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    let timetableService = TimeTableService()
    let dateManager = DateManager()
    let settingsManager = SettingsManager()
    
    // MARK: - Init
    init(id: String, currentDate: String, owner: String, dayType: DayType, week: WeekModel, dates: [String]) {
        self.id = id
        self.currentDate = currentDate
        self.owner = owner
        self.dayType = dayType
        self.week = week
        self.dates = dates
    }
}
