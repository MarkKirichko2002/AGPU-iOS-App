//
//  PairInfoViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.10.2023.
//

import Foundation

// MARK: - PairInfoViewModelProtocol
extension PairInfoViewModel: PairInfoViewModelProtocol {
    
    func setUpData() {
        let startTime = getStartTime()
        let endTime = getEndTime()
        let pairType = getPairType(type: pair.type)
        let subGroup = checkSubGroup(subgroup: pair.subgroup)
        pairInfo.append("дата: \(date)")
        pairInfo.append("начало: \(startTime)")
        pairInfo.append("конец: \(endTime)")
        pairInfo.append("подгруппа: \(subGroup)")
        pairInfo.append("тип пары: \(pairType)")
        pairInfo.append("аудитория: \(pair.audienceID)")
        pairInfo.append("дисциплина: \(pair.name)")
        pairInfo.append("преподаватель: \(pair.teacherName)")
        pairInfo.append("группа: \(pair.groupName)")
        pairInfo.append("до начала осталось: 0 часов 0 минут")
        dataChangedHandler?()
        checkCurrentTime()
    }
    
    func getFacultyIcon(group: String)-> String {
        let group = FacultyGroups.groups.first { $0.groups.contains { $0 == group } }
        if let faculty = AGPUFaculties.faculties.first(where: { $0.name == group?.facultyName.removeLastWords() }) {
            print(faculty)
            return faculty.icon
        }
        return "info"
    }
    
    func getStartTime()-> String {
        let times = pair.time.components(separatedBy: "-")
        let startTime = times[0] + ":00"
        return startTime
    }
    
    func getEndTime()-> String {
        let times = pair.time.components(separatedBy: "-")
        let startTime = times[1] + ":00"
        return startTime
    }
    
    func getPairType(type: PairType)-> String {
        switch type {
        case .lec:
            return "лекция"
        case .prac:
            return "практика"
        case .exam:
            return "экзамен"
        case .lab:
            return "лабораторная работа"
        case .hol:
            return "каникулы"
        case .cred:
            return "зачет"
        case .fepo:
            return "ФЭПО"
        case .cons:
            return "консультация"
        case .none:
            return "другое"
        case .all:
            return ""
        }
    }
    
    func checkSubGroup(subgroup: Int)-> String {
        if subgroup == 0 && !pair.name.contains("Дисциплина по выбору") {
            return "общая пара"
        } else if pair.name.contains("Дисциплина по выбору") {
            return "отсутствует"
        } else {
            return "\(subgroup)"
        }
    }
    
    func checkIsCurrentGroup(index: Int)-> Bool {
        let savedGroup = UserDefaults.standard.string(forKey: "group") ?? ""
        if pairInfo[index].contains(savedGroup) {
            return true
        } else {
            return false
        }
    }
    
    func startTimer() {
        print("timer fired")
        timer?.fire()
    }
    
    func stopTimer() {
        print("timer stopped")
        timer?.invalidate()
    }
    
    func checkCurrentTime() {
        // текущая дата
        let currentDate = dateManager.getCurrentDate()
        // начало пары
        let startTime = getStartTime()
        // текущее время
        let currentTime = dateManager.getCurrentTime()
        // сравнение двух дат
        let dateComparisonResult = dateManager.compareDates(date1: currentDate, date2: date)
        // сравнени двух времен
        let timeComparisonResult = dateManager.compareTimes(time1: currentTime, time2: startTime)
        
        if dateComparisonResult == .orderedSame && timeComparisonResult == .orderedAscending {
            startTimer()
            getTimeLeftToStart()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.getTimeLeftToStart()
            }
        } else if dateComparisonResult == .orderedAscending {
            startTimer()
            getTimeLeftToStartInFuture()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.getTimeLeftToStartInFuture()
            }
        } else if dateComparisonResult == .orderedDescending {
            startTimer()
            getTimeEnded()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.getTimeEnded()
            }
        } else {
            startTimer()
            getTimeLeftToStart()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.getTimeLeftToStart()
            }
        }
    }
    
    // время до начала пары
    func getTimeLeftToStart() {
        
        let calendar = Calendar.current
        
        let times = getStartTime().components(separatedBy: ":")
        
        let startHour = times[0]
        let endHour = times[1]
        
        var components = DateComponents()
        components.hour = Int(startHour)
        components.minute = Int(endHour)
        
        let currentDate = Date()
        
        if let startDate = calendar.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: currentDate) {
            
            let difference = calendar.dateComponents([.hour, .minute, .second], from: currentDate, to: startDate)
            
            if let hours = difference.hour, let minutes = difference.minute, let seconds = difference.second {
                
                if hours <= 0 && minutes <= 0 && seconds <= 0 {
                    self.pairInfo[9] = "пара уже началась"
                    self.dataChangedHandler?()
                    self.getTimeLeftToEnd()
                } else {
                    self.pairInfo[9] = "до начала: \(hours) часов \(minutes) минут \(seconds) секунд"
                    self.dataChangedHandler?()
                }
            } else {
                print("Ошибка")
            }
        } else {
            print("Ошибка при установке времени начала пары")
        }
    }
    
    // время до конца пары
    func getTimeLeftToEnd() {
        
        let calendar = Calendar.current
        
        let times = getEndTime().components(separatedBy: ":")
        
        let startHour = times[0]
        let endHour = times[1]
        
        var components = DateComponents()
        components.hour = Int(startHour)
        components.minute = Int(endHour)
        
        let currentDate = Date()
        
        if let startDate = calendar.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: currentDate) {
            
            let difference = calendar.dateComponents([.hour, .minute, .second], from: currentDate, to: startDate)
            
            if let hours = difference.hour, let minutes = difference.minute, let seconds = difference.second {
                
                if hours >= 0 && minutes >= 0 && seconds >= 0 {
                    print(hours)
                    print(minutes)
                    print(seconds)
                    self.pairInfo[9] = "до конца пары: \(hours) часов \(minutes) минут \(seconds) секунд"
                    self.dataChangedHandler?()
                } else if hours <= 0 && minutes <= 0 && seconds <= 0 {
                    print(hours)
                    print(minutes)
                    print(seconds)
                    self.pairInfo[9] = "пара закончилась: \(abs(hours)) часов \(abs(minutes)) минут \(abs(seconds)) секунд назад"
                    self.dataChangedHandler?()
                }
            } else {
                print("Ошибка")
            }
        } else {
            print("Ошибка при установке времени начала пары")
        }
    }
    
    // время до начала пары в будущем
    func getTimeLeftToStartInFuture() {
        
        let calendar = Calendar.current
        
        let times = dateManager.getCurrentTime()
        
        let startTimes = getStartTime().components(separatedBy: ":")
        let startHour = startTimes[0]
        let endHour = startTimes[1]
        
        let dates = date.components(separatedBy: ".")
        var components = DateComponents()
        components.day = Int(dates[0])
        components.month = Int(dates[1])
        components.year = Int(dates[2])
        
        let currentDate = dateManager.getCurrentDate() + " \(times)"
        let startDate = calendar.date(from: components)!
        let startDateString = dateManager.getFormattedDate(date: startDate) + " \(startHour):\(endHour):00"
        
        print(currentDate)
        print(startDateString)
        
        let info = dateManager.getInfoFromDates(date: currentDate, date2: startDateString)
        
        self.pairInfo[9] = "осталось: \(abs(info.day ?? 0)) дней \(abs(info.hour ?? 0)) часов \(abs(info.minute ?? 0)) минут \(abs(info.second ?? 0)) секунд"
        self.dataChangedHandler?()
    }
    
    func getTimeEnded() {
        
        let calendar = Calendar.current
        
        let times = dateManager.getCurrentTime()
        
        let startTimes = getEndTime().components(separatedBy: ":")
        let startHour = startTimes[0]
        let endHour = startTimes[1]
        
        let dates = date.components(separatedBy: ".")
        var components = DateComponents()
        components.day = Int(dates[0])
        components.month = Int(dates[1])
        components.year = Int(dates[2])
        
        let currentDate = dateManager.getCurrentDate() + " \(times)"
        let startDate = calendar.date(from: components)!
        let startDateString = dateManager.getFormattedDate(date: startDate) + " \(startHour):\(endHour):00"
        
        print(currentDate)
        print(startDateString)
        
        let info = dateManager.getInfoFromDates(date: currentDate, date2: startDateString)
        
        pairInfo[9] = "прошло с окончания: \(abs(info.day ?? 0)) дней \(abs(info.hour ?? 0)) часов \(abs(info.minute ?? 0)) минут \(abs(info.second ?? 0)) секунд"
        self.dataChangedHandler?()
    }
        
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
