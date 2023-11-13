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
    func getCurrentDayOfWeek(date: String)-> String
    func getFormattedDate(date: Date)-> String
    func nextDay(date: String)-> String
    func previousDay(date: String)-> String
    func dateRange(startDate: String, endDate: String)-> Bool
    func timeRange(startTime: String, endTime: String, currentTime: String)-> Bool
    func compareDates(date1: String, date2: String)-> ComparisonResult
    func compareTimes(time1: String, time2: String)-> ComparisonResult
    func compareDaysCount(date: String, date2: String)-> Int
    func getInfoFromDates(date: String, date2: String)-> DateComponents
}
