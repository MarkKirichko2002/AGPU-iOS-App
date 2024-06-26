//
//  TimeTableDatesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation

class TimeTableDatesListViewModel {
    
    // MARK: - сервисы
    let service = TimeTableService()
    let realmManager = RealmManager()
    let dateManager = DateManager()
    
    var timetable = [TimeTableDayModel]()
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
