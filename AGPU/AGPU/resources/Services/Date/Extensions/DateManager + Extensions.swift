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
}
