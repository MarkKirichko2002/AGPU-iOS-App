//
//  CalendarViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import UIKit

protocol CalendarViewModelProtocol {
    func checkTimetable(date: Date)
    func getPairsCount(pairs: [Discipline])-> Int
    func getTestsCount(pairs: [Discipline])-> Int
    func getConsCount(pairs: [Discipline])-> Int
    func getExamsCount(pairs: [Discipline])-> Int
    func sendNotificationDataWasSelected(date: String)
    func registerTimetableAlertHandler(block: @escaping(String, String, UIColor)->Void)
    func registerDateSelectedHandler(block: @escaping()->Void)
}
