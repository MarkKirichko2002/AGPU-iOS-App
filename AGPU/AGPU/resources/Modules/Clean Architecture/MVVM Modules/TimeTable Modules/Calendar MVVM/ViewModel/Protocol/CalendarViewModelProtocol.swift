//
//  CalendarViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import Foundation

protocol CalendarViewModelProtocol {
    func checkTimetable(date: Date)
    func getPairsCount(pairs: [Discipline])-> Int
    func sendNotificationDataWasSelected(date: String)
    func registerTimetableAlertHandler(block: @escaping(String, String)->Void)
    func registerDateSelectedHandler(block: @escaping()->Void)
}
