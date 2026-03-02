//
//  RecentMomentsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import Foundation

final class RecentMomentsListViewModel {
    
    let style = SettingsManager().getSavedCommunicationStyle()
    let name = UserDefaults.standard.string(forKey: "name") ?? ""
    var timetable = TimeTable(id: "", date: "", disciplines: []) {
        didSet {
            timetable.disciplines = timetablePseudonymManager.setUpTimetablePseudonyms(pairs: &timetable.disciplines)
            timetable.disciplines = timetable.disciplines.sorted { dateManager.compareTimes(time1: "\($0.time.components(separatedBy: "-")[0]):00", time2: "\($1.time.components(separatedBy: "-")[0]):00") == .orderedAscending}
        }
    }
    
    var alertHandler: ((String, String)->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    let service = TimeTableService()
    let dateManager = DateManager()
    let timetablePseudonymManager = PseudonymManager()
    
}
