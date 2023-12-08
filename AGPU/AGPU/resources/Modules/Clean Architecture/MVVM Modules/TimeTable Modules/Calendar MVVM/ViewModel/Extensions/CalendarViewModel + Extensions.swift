//
//  CalendarViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import UIKit

// MARK: - CalendarViewModelProtocol
extension CalendarViewModel: CalendarViewModelProtocol {
    
    func checkTimetable(date: Date) {
        let date = dateManager.getFormattedDate(date: date)
        self.date = date
        service.getTimeTableDay(groupId: group, date: date) { [weak self] result in
            switch result {
            case .success(let data):
                // выходной
                if data.disciplines.contains(where: { $0.type == .hol }) {
                    self?.timetableHandler?("Праздничный выходной", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(self?.dateManager.getCurrentDate() ?? "") занятий нет", UIColor.systemGray)
                }
                // практика
                if data.disciplines.contains(where: { $0.name.contains("практика") }) {
                    
                    let startTimes = data.disciplines[0].time.components(separatedBy: "-")
                    let startTime = startTimes[0]
                    
                    let endTimes = data.disciplines[data.disciplines.count - 1].time.components(separatedBy: "-")
                    let endTime = endTimes[1]
                    
                    self?.timetableHandler?("В этот день есть практика!", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date), количество пар: \(self?.getPairsCount(pairs: data.disciplines) ?? 0), начало: \(startTime), конец: \(endTime)", UIColor.systemYellow)
                }
                // зачет
                if data.disciplines.contains(where: { $0.type == .cred }) {
                    
                    let startTimes = data.disciplines[0].time.components(separatedBy: "-")
                    let startTime = startTimes[0]
                    
                    let endTimes = data.disciplines[data.disciplines.count - 1].time.components(separatedBy: "-")
                    let endTime = endTimes[1]
                    let pairsCount = self?.getPairsCount(pairs: data.disciplines) ?? 0
                    let testsCount = self?.getTestsCount(pairs: data.disciplines) ?? 0
                    
                    self?.timetableHandler?("В этот день есть \(testsCount > 1 ? "зачёты!" : "зачёт!")", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date), пар: \(pairsCount), зачётов: \(testsCount), начало: \(startTime), конец: \(endTime)", UIColor.systemYellow)
                }
                
                // консультация
                if data.disciplines.contains(where: { $0.type == .cons }) {
                    
                    let startTimes = data.disciplines[0].time.components(separatedBy: "-")
                    let startTime = startTimes[0]
                    
                    let endTimes = data.disciplines[data.disciplines.count - 1].time.components(separatedBy: "-")
                    let endTime = endTimes[1]
                    let consCount = self?.getConsCount(pairs: data.disciplines) ?? 0
                    
                    self?.timetableHandler?("В этот день консультация!", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date), консультаций: \(consCount), \nначало: \(startTime), конец: \(endTime)", UIColor.systemYellow)
                }
                // экзамен
                if data.disciplines.contains(where: { $0.type == .exam }) {
                    
                    let startTimes = data.disciplines[0].time.components(separatedBy: "-")
                    let startTime = startTimes[0]
                    
                    let endTimes = data.disciplines[data.disciplines.count - 1].time.components(separatedBy: "-")
                    let endTime = endTimes[1]
                    let examsCount = self?.getExamsCount(pairs: data.disciplines) ?? 0
                    
                    self?.timetableHandler?("В этот день есть \(examsCount > 1 ? "экзамены!" : "экзамен!")", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date), экзаменов: \(examsCount), \nначало: \(startTime), конец: \(endTime)", UIColor.systemRed)
                }
                // расписание есть
                if !data.disciplines.isEmpty {
                    
                    let startTimes = data.disciplines[0].time.components(separatedBy: "-")
                    let startTime = startTimes[0]
                    
                    let endTimes = data.disciplines[data.disciplines.count - 1].time.components(separatedBy: "-")
                    let endTime = endTimes[1]
                    let pairsCount = self?.getPairsCount(pairs: data.disciplines) ?? 0
                    
                    self?.timetableHandler?("В этот день есть \(pairsCount > 1 ? "пары" : "пара")", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date), количество пар: \(pairsCount), начало: \(startTime), конец: \(endTime)", UIColor.systemGreen)
                } else {
                // расписания нет
                    self?.timetableHandler?("Расписание отсутствует", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date) нет пар", UIColor.systemGray)
                }
            case .failure(let error):
                print(error)
            }
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    // подсчет пар
    func getPairsCount(pairs: [Discipline])-> Int {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in pairs {
            
            if pair.type != .cred {
                
                let times = pair.time.components(separatedBy: "-")
                let startTime = times[0]
                
                uniqueTimes.insert(startTime)
            }
        }
        
        return uniqueTimes.count
    }
    
    // подсчет зачетов
    func getTestsCount(pairs: [Discipline])-> Int {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in pairs {
            
            if pair.type == .cred {
                
                let times = pair.time.components(separatedBy: "-")
                let startTime = times[0]
                
                uniqueTimes.insert(startTime)
            }
        }
        
        return uniqueTimes.count
    }
    
    // подсчет консультаций
    func getConsCount(pairs: [Discipline])-> Int {
        
        var uniqueCons: Set<String> = Set()
        
        for pair in pairs {
            
            if pair.type == .cons {
                uniqueCons.insert(pair.name)
            }
        }
        
        return uniqueCons.count
    }
    
    // подсчет экзаменов
    func getExamsCount(pairs: [Discipline])-> Int {
        
        var uniqueExams: Set<String> = Set()
        
        for pair in pairs {
            
            if pair.type == .exam {
                uniqueExams.insert(pair.name)
            }
        }
        
        return uniqueExams.count
    }
    
    func sendNotificationDataWasSelected(date: String) {
        NotificationCenter.default.post(name: Notification.Name("DateWasSelected"), object: date)
    }
    
    func registerTimetableAlertHandler(block: @escaping(String, String, UIColor)->Void) {
        self.timetableHandler = block
    }
    
    func registerDateSelectedHandler(block: @escaping()->Void) {
        self.dateSelectedHandler = block
    }
}
