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
    func registerDateSelectedHandler(block: @escaping()->Void)
    func registerAlertHandler(block: @escaping()->Void)
}
