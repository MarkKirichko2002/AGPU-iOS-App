//
//  DateManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 07.07.2023.
//

import Foundation

protocol DateManagerProtocol {
    func getCurrentDate()-> String
    func getCurrentTime()-> String
    func nextDay(date: String)-> String
    func previousDay(date: String)-> String
    func getWeekId(date: String)-> Int
    func countDays(startDate: String, endDate: String)-> Int
}
