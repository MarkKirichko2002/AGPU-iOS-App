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
        checkIsCurrentTime()
    }
    
    func getStartTime()-> String {
        let times = pair.time.components(separatedBy: "-")
        let startTime = times[0]
        return startTime
    }
    
    func getEndTime()-> String {
        let times = pair.time.components(separatedBy: "-")
        let startTime = times[1]
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
        timer?.fire()
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func checkIsCurrentTime() {
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
        // количество дней
        let daysCount = dateManager.compareDaysCount(date: currentDate, date2: date)
        
        if dateComparisonResult == .orderedSame && timeComparisonResult == .orderedAscending {
            getLeftTime()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.getLeftTime()
            }
        } else if dateComparisonResult == .orderedAscending {
            pairInfo[9] = "пара будет через: \(daysCount) дня"
        } else if dateComparisonResult == .orderedDescending {
            pairInfo[9] = "пара закончилась \(daysCount) дня назад"
        } else {
            pairInfo[9] = "пара уже закончилась"
        }
    }
        
    func getLeftTime() {
        
        let calendar = Calendar.current
        
        let times = getStartTime().components(separatedBy: ":")
        
        let startHour = times[0]
        let endHour = times[1]
        
        var components = DateComponents()
        components.hour = Int(startHour)
        components.minute = Int(endHour)
        
        let currentDate = Date()
        
        if let startDate = calendar.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: currentDate) {
            
            let difference = calendar.dateComponents([.hour, .minute], from: currentDate, to: startDate)
            
            if let hours = difference.hour, let minutes = difference.minute {
                if hours < 0 && minutes < 0 {
                    self.pairInfo[9] = "пара закончилась \(abs(hours)) часов \(abs(minutes)) минут назад"
                } else {
                    self.pairInfo[9] = "до начала осталось: \(hours) часов \(minutes) минут"
                }
                self.dataChangedHandler?()
            } else {
                print("Ошибка")
            }
        } else {
            print("Ошибка при установке времени начала пары")
        }
    }
        
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
