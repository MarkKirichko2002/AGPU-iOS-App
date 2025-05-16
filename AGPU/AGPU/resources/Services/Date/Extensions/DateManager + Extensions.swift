//
//  DateManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation

// MARK: - DateManagerProtocol
extension DateManager: DateManagerProtocol {
    
    func makeDateComponents(date: String)-> DateComponents {
        var components = DateComponents()
        let dateParts = date.components(separatedBy: ".")
        components.day = Int(dateParts[0])
        components.month = Int(dateParts[1])
        components.year = Int(dateParts[2])
        return components
    }
    
    func getCurrentDate()-> String {
        var currentDate = ""
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    func getCurrentYear()-> Int {
        return calendar.component(.year, from: date)
    }
    
    func getCurrentMonth()-> Int {
        let date = Date()
        return calendar.component(.month, from: date)
    }
    
    func getCurrentTime(isFullFormat: Bool)-> String {
        let date = Date()
        if isFullFormat {
            dateFormatter.dateFormat = "HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    func getCurrentDayOfWeek(date: String)-> String {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let date = dateFormatter.date(from: date) {
            let dayOfWeek = calendar.component(.weekday, from: date)
            return daysOfWeek[dayOfWeek - 1]
        }
        return ""
    }
    
    func getDate(from weekDay: String)-> String {
        return ""
    }
    
    func getCurrentDayOfWeek(day: Int)-> String {
        let day = daysOfWeek[day]
        return day
    }
    
    func getFormattedDate(date: Date)-> String {
        var currentDate = ""
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    func getFormattedDate(from text: String)-> String {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDate = dateFormatter.date(from: text)
        let formattedDate = getFormattedDate(date: currentDate!)
        return formattedDate
    }
    
    func getDateFromString(str: String, withTime: Bool)-> Date? {
        if withTime {
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy"
        }
        if let currentDate = dateFormatter.date(from: str) {
            return currentDate
        }
        return nil
    }
    
    func getDateFromWords(date: String)-> String {
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM"
        var components = DateComponents()
        if let result = dateFormatter.date(from: date) {
            components.day = calendar.component(.day, from: result)
            components.month = calendar.component(.month, from: result)
            components.year = getCurrentYear()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: calendar.date(from: components)!)
        }
        return ""
    }
    
    func checkDateFromWords(text: String)-> Bool {
        let day = text.getNumberFromString()
        if text.contains("феврал") {
            let daysCount = getMonthDaysCount(date: "01.02.2025")
            if Int(day) ?? 0 <= daysCount {
                return true
            }
        } else {
            let daysCount = getMonthDaysCount(date: getDateFromWords(date: text))
            if Int(day) ?? 0 <= daysCount {
                return true
            }
        }
        return false
    }
    
    func isCorrectFormat(str: String)-> Bool {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let _ = dateFormatter.date(from: str) {
            return true
        }
        return false
    }
    
    func nextDay(date: String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        var nextDay = ""
        
        if let date = dateFormatter.date(from: date) {
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
            var dateComponent = DateComponents()
            dateComponent.day = -1
            
            if let yesterday = calendar.date(byAdding: dateComponent, to: date) {
                let yesterdayString = dateFormatter.string(from: yesterday)
                previousDay = yesterdayString
            }
        }
        return previousDay
    }
    
    func addingTime(addTime: String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let currentDate = Date()
        let addingTime = dateFormatter.date(from: addTime) ?? Date()
        
        var dateComponent = DateComponents()
        dateComponent.hour = calendar.component(.hour, from: addingTime)
        dateComponent.minute = calendar.component(.minute, from: addingTime)
        
        if let time = calendar.date(byAdding: dateComponent, to: currentDate) {
            return dateFormatter.string(from: time)
        }
        
        return ""
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
        dateFormatter.dateFormat = "HH:mm"
        
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
    
    func getMonthDaysCount(date: String)-> Int {
        var convertedDate = Date()
        var count = 0
        let dateitems = date.components(separatedBy: ".")
        if dateitems.count > 1 {
            if dateitems[1] == "02" {
                convertedDate = getDateFromString(str: "01.02.\(dateitems[2])", withTime: false) ?? Date()
            } else {
                convertedDate = getDateFromString(str: date, withTime: false) ?? Date()
            }
        }
        count = calendar.range(of: .day, in: .month, for: convertedDate)?.count ?? 0
        return count
    }
}
