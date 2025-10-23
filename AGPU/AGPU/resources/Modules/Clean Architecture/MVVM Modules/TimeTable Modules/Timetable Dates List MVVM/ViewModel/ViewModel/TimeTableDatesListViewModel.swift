//
//  TimeTableDatesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation

final class TimeTableDatesListViewModel {
    
    // MARK: - сервисы
    let service = TimeTableService()
    let realmManager = RealmManager()
    let dateManager = DateManager()
    let settingsManager = SettingsManager()
    let timetablePseudonymManager = TimetablePseudonymManager()
    let timetableMenuManager = TimetableMenuManager()
    
    var timetable = [TimeTableDayModel]() {
        didSet {
            timetable = timetable.map { day in
                var modifiedDay = day
                modifiedDay.disciplines = self.timetablePseudonymManager.setUpTimetablePseudonyms(pairs: &modifiedDay.disciplines)
                return modifiedDay
            }
        }
    }
    var id: String = ""
    var owner: String = ""
    var dates = [String]()
    var dataChangedHandler: (()->Void)?
    
    // MARK: - Init
    init(id: String, owner: String, dates: [String]) {
        self.id = id
        self.owner = owner
        self.dates = dates
    }
}
