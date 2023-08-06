//
//  DateManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation

// MARK: - DateManagerProtocol
extension DateManager: DateManagerProtocol {
    
    func getCurrentDate()-> String {
        var currentDate = ""
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    func getCurrentTime()-> String {
        let date = Date()
        dateFormatter.dateFormat = "HH:mm:ss"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    func nextDay(date: String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        var nextDay = ""
        
        if let date = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            var dateComponent = DateComponents()
            dateComponent.day = 1
            
            if let tomorrow = calendar.date(byAdding: dateComponent, to: date) {
                let tomorrowString = dateFormatter.string(from: tomorrow)
                nextDay = tomorrowString
            }
        }
        return nextDay
    }
    
    func previousDay(date: String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        var previousDay = ""
        
        if let date = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            var dateComponent = DateComponents()
            dateComponent.day = -1
            
            if let yesterday = calendar.date(byAdding: dateComponent, to: date) {
                let yesterdayString = dateFormatter.string(from: yesterday)
                previousDay = yesterdayString
            }
        }
        return previousDay
    }
    
    func getWeekId(date: String)-> Int {
        let mappingWeekId = 1
        let weekId = mappingWeekId + countDays(startDate: "29.08.2022", endDate: date) / 7
        return weekId
    }
    
    func countDays(startDate: String, endDate: String)-> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        let startDateObj = dateFormatter.date(from: startDate)!
        let endDateObj = dateFormatter.date(from: endDate)!

        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDateObj)
        let end = calendar.startOfDay(for: endDateObj)

        let dateComponents = calendar.dateComponents([.day], from: start, to: end)

        return dateComponents.day!
    }
}
