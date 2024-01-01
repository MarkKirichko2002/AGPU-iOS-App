//
//  DaysListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import UIKit

// MARK: - DaysListViewModelProtocol
extension DaysListViewModel: DaysListViewModelProtocol {
    
    func setUpData() {
        
        // даты
        DaysList.days[0].date = dateManager.getCurrentDate()
        DaysList.days[1].date = currentDate
        DaysList.days[2].date = dateManager.nextDay(date: currentDate)
        DaysList.days[3].date = dateManager.previousDay(date: currentDate)
        
        // дни недели
        DaysList.days[0].dayOfWeek = dateManager.getCurrentDayOfWeek(date: dateManager.getCurrentDate())
        DaysList.days[1].dayOfWeek = dateManager.getCurrentDayOfWeek(date: currentDate)
        DaysList.days[2].dayOfWeek = dateManager.getCurrentDayOfWeek(date: dateManager.nextDay(date: currentDate))
        DaysList.days[3].dayOfWeek = dateManager.getCurrentDayOfWeek(date: dateManager.previousDay(date: currentDate))
        
        // информация о количестве пар
        DaysList.days[0].info = "загрузка..."
        DaysList.days[1].info = "загрузка..."
        DaysList.days[2].info = "загрузка..."
        DaysList.days[3].info = "загрузка..."
        
        getTimetableInfo()
    }
    
    func getTimetableInfo() {
        let dispatchGroup = DispatchGroup()
        for day in DaysList.days {
            dispatchGroup.enter()
            timetableService.getTimeTableDay(groupId: group, date: day.date) { [weak self] result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let timetable):
                    if !timetable.disciplines.isEmpty {
                        // просто расписание
                        let day = DaysList.days.first { $0.name == day.name }
                        let index = DaysList.days.firstIndex(of: day!)
                        DaysList.days[index!].info = "пар: \(self?.getPairsCount(pairs: timetable.disciplines) ?? 0)"
                        // особые дни
                        let coursesCount = self?.getCoursesCount(pairs: timetable.disciplines) ?? 0
                        let testsCount = self?.getTestsCount(pairs: timetable.disciplines) ?? 0
                        let consCount = self?.getConsCount(pairs: timetable.disciplines) ?? 0
                        let examsCount = self?.getExamsCount(pairs: timetable.disciplines) ?? 0
                        
                        if coursesCount > 0 {
                            DaysList.days[index!].info = coursesCount > 1 ? "курсовые" : "курсовая!"
                        } else if testsCount > 0 {
                            DaysList.days[index!].info = testsCount > 1 ? "зачеты" : "зачет"
                        } else if consCount > 0 {
                            DaysList.days[index!].info = consCount > 1 ? "консультации" : "консультация"
                        } else if examsCount > 0 {
                            DaysList.days[index!].info = examsCount > 1 ? "экзамены!" : "экзамен!"
                        }
                    } else {
                        let day = DaysList.days.first { $0.name == day.name }
                        let index = DaysList.days.firstIndex(of: day!)
                        DaysList.days[index!].info = "нет пар"
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.dataChangedHandler?()
        }
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
    
    // подсчет курсовых
    func getCoursesCount(pairs: [Discipline])-> Int {
        
        var uniqueCourses: Set<String> = Set()
        
        for pair in pairs {
            
            if pair.name.contains("курсов.") {
                uniqueCourses.insert(pair.name)
            }
        }
        
        return uniqueCourses.count
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
    
    func chooseDay(index: Int) {
        let day = DaysList.days[index]
        NotificationCenter.default.post(name: Notification.Name("DateWasSelected"), object: day.date)
        AudioPlayerClass.shared.playSound(sound: "paper")
        HapticsManager.shared.hapticFeedback()
    }
    
    func timeTableColor(index: Int)-> UIColor {
        let day = DaysList.days[index]
        if day.info.contains("пар:") {
            return .systemGreen
        } else if day.info.contains("зачет") || day.info.contains("конс")  {
            return .systemYellow
        } else if day.info.contains("экзамен") || day.info.contains("курс")  {
            return .systemRed
        } else {
            return .systemGray
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
