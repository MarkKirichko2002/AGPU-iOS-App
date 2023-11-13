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
    
    func getCurrentDayOfWeek(date: String)-> String {
        let calendar = Calendar.current
        if let date = dateFormatter.date(from: date) {
            let dayOfWeek = calendar.component(.weekday, from: date)
            return daysOfWeek[dayOfWeek - 1]
        }
        return ""
    }
    
    func getFormattedDate(date: Date)-> String {
        var currentDate = ""
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    func getDateFromString(str: String)-> Date? {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let currentDate = dateFormatter.date(from: str) {
            return currentDate
        }
        return nil
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
    
    func dateRange(startDate: String, endDate: String)-> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let startDateString = startDate
        let endDateString = endDate
        let currentDateString = getCurrentDate()
        
        if let startDate = dateFormatter.date(from: startDateString),
           let endDate = dateFormatter.date(from: endDateString),
           let currentDate = dateFormatter.date(from: currentDateString) {
            
            if (startDate...endDate).contains(currentDate) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func timeRange(startTime: String, endTime: String, currentTime: String)-> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        if let startTime = dateFormatter.date(from: startTime),
           let endTime = dateFormatter.date(from: endTime),
           let currentTime = dateFormatter.date(from: currentTime) {
            
            if (startTime...endTime).contains(currentTime) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func compareDates(date1: String, date2: String)-> ComparisonResult {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let date1 = dateFormatter.date(from: date1)
        let date2 = dateFormatter.date(from: date2)
        
        if let firstDate = date1, let secondDate = date2 {
            
            let comparisonResult = firstDate.compare(secondDate)
            
            return comparisonResult
            
        } else {
            print("Ошибка при создании даты")
        }
        
        return .orderedAscending
    }
    
    func compareTimes(time1: String, time2: String)-> ComparisonResult {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let time1 = dateFormatter.date(from: time1)
        let time2 = dateFormatter.date(from: time2)
        
        if let firstTime = time1, let secondTime = time2 {
            
            let comparisonResult = firstTime.compare(secondTime)
            
            return comparisonResult
            
        } else {
            print("Ошибка при создании времени")
        }
        
        return .orderedAscending
    }
    
    func compareDaysCount(date: String, date2: String)-> Int {
        
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        if let startDate = dateFormatter.date(from: date),
           let endDate = dateFormatter.date(from: date2) {
            
            let components = calendar.dateComponents([.day], from: endDate, to: startDate)
            
            if let days = components.day {
                return abs(days)
            } else {
                print("Ошибка при вычислении количества дней")
            }
        } else {
            print("Ошибка при создании даты")
        }
        return 0
    }
    
    func getInfoFromDates(date: String, date2: String)-> DateComponents {
        
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        var info = DateComponents()
        
        if let firstDate = dateFormatter.date(from: date) ,
           let startDate = dateFormatter.date(from: date2) {
            
            let components = calendar.dateComponents([.day, .hour, .minute, .second], from: firstDate, to: startDate)
                        
            if let days = components.day, let hours = components.hour, let minutes = components.minute, let seconds = components.second {
                info.day = days
                info.hour = hours
                info.minute = minutes
                info.second = seconds
                print(seconds)
            } else {
                print("Ошибка при вычислении количества дней")
            }
        } else {
            print("Ошибка при создании даты")
        }
        return info
    }
}
