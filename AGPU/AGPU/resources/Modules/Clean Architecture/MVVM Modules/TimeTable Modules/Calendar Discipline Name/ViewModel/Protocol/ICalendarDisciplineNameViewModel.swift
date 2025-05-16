//
//  ICalendarDisciplineNameViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.04.2025.
//

import Foundation

protocol ICalendarDisciplineNameViewModel {
    func getFormattedDate(date: Date)-> String
    func checkTimetable(date: String, name: String)
    func registerAlertHandler(block: @escaping(String, String)->Void)
}
