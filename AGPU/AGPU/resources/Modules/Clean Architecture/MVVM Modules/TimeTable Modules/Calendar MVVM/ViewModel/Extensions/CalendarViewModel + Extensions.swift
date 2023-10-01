//
//  CalendarViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import Foundation

// MARK: - CalendarViewModelProtocol
extension CalendarViewModel: CalendarViewModelProtocol {
    
    func sendNotificationDataWasSelected(date: String) {
        NotificationCenter.default.post(name: Notification.Name("DateWasSelected"), object: date)
    }
    
    func checkTimetable(date: Date) {
        let date = dateManager.getFormattedDate(date: date)
        self.date = date
        service.getTimeTableDay(groupId: group, date: date) { [weak self] result in
            switch result {
            case .success(let data):
                if !data.disciplines.isEmpty {
                    self?.timetableHandler?()
                } else {
                    self?.noTimetableHandler?()
                }
            case .failure(let error):
                print(error)
            }
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    func registerTimetableAlertHandler(block: @escaping()->Void) {
        self.timetableHandler = block
    }
    
    func registerNoTimetableAlertHandler(block: @escaping()->Void) {
        self.noTimetableHandler = block
    }
    
    func registerDateSelectedHandler(block: @escaping()->Void) {
        self.dateSelectedHandler = block
    }
}
