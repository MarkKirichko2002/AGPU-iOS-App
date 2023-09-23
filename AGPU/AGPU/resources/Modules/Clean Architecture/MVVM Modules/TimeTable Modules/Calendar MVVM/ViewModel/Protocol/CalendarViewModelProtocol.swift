//
//  CalendarViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import Foundation

protocol CalendarViewModelProtocol {
    func sendNotificationDataWasSelected(date: String)
    func checkTimetable(date: Date)
    func registerTimetableAlertHandler(block: @escaping()->Void)
    func registerNoTimetableAlertHandler(block: @escaping()->Void)
    func registerDateSelectedHandler(block: @escaping()->Void)
}
