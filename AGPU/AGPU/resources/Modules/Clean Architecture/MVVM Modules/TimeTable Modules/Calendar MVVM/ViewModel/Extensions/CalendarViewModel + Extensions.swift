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
                
                if data.disciplines.contains(where: { $0.type == .hol }) {
                    self?.timetableHandler?("Праздничный выходной", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(self?.dateManager.getCurrentDate() ?? "") занятий нет", UIColor.systemGray)
                }
                
                if data.disciplines.contains(where: { $0.name.contains("практика") }) {
                    
                    let startTimes = data.disciplines[0].time.components(separatedBy: "-")
                    let startTime = startTimes[0]
                    
                    let endTimes = data.disciplines[data.disciplines.count - 1].time.components(separatedBy: "-")
                    let endTime = endTimes[1]
                    
                    self?.timetableHandler?("В этот день есть практика!", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date), количество пар: \(self?.getPairsCount(pairs: data.disciplines) ?? 0), начало: \(startTime), конец: \(endTime)", UIColor.systemYellow)
                }
                
                if data.disciplines.contains(where: { $0.type == .cred }) {
                    
                    let startTimes = data.disciplines[0].time.components(separatedBy: "-")
                    let startTime = startTimes[0]
                    
                    let endTimes = data.disciplines[data.disciplines.count - 1].time.components(separatedBy: "-")
                    let endTime = endTimes[1]
                    
                    self?.timetableHandler?("В этот день есть зачёт!", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date), пар: \(self?.getPairsCount(pairs: data.disciplines) ?? 0), зачётов: \(self?.getTestsCount(pairs: data.disciplines) ?? 0), начало: \(startTime), конец: \(endTime)", UIColor.systemYellow)
                }
                
                if !data.disciplines.isEmpty {
                    
                    let startTimes = data.disciplines[0].time.components(separatedBy: "-")
                    let startTime = startTimes[0]
                    
                    let endTimes = data.disciplines[data.disciplines.count - 1].time.components(separatedBy: "-")
                    let endTime = endTimes[1]
                    
                    self?.timetableHandler?("Расписание найдено", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date), количество пар: \(self?.getPairsCount(pairs: data.disciplines) ?? 0), начало: \(startTime), конец: \(endTime)", UIColor.systemGreen)
                } else {
                    self?.timetableHandler?("Расписание отсутствует", "\(self?.dateManager.getCurrentDayOfWeek(date: date) ?? "") \(date) нет пар", UIColor.systemGray)
                }
            case .failure(let error):
                print(error)
            }
        }
        HapticsManager.shared.hapticFeedback()
    }
    
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
