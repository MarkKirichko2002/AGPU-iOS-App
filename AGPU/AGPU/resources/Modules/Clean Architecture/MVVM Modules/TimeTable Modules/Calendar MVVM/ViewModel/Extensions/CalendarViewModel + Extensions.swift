//
//  CalendarViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import Foundation

// MARK: - CalendarViewModelProtocol
extension CalendarViewModel: CalendarViewModelProtocol {
    
    func checkTimetable(date: Date) {
        let date = dateManager.getFormattedDate(date: date)
        self.date = date
        service.getTimeTableDay(groupId: group, date: date) { [weak self] result in
            switch result {
            case .success(let data):
                if !data.disciplines.isEmpty {
                    self?.timetableHandler?("\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date) количество пар: \(self?.getPairsCount(pairs: data.disciplines) ?? 0)")
                } else {
                    self?.noTimetableHandler?("\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date) нет пар")
                }
            case .failure(let error):
                print(error)
            }
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    func getPairsCount(pairs: [Discipline])-> Int {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in pairs {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
    }
    
    func sendNotificationDataWasSelected(date: String) {
        NotificationCenter.default.post(name: Notification.Name("DateWasSelected"), object: date)
    }
    
    func registerTimetableAlertHandler(block: @escaping(String)->Void) {
        self.timetableHandler = block
    }
    
    func registerNoTimetableAlertHandler(block: @escaping(String)->Void) {
        self.noTimetableHandler = block
    }
    
    func registerDateSelectedHandler(block: @escaping()->Void) {
        self.dateSelectedHandler = block
    }
}
