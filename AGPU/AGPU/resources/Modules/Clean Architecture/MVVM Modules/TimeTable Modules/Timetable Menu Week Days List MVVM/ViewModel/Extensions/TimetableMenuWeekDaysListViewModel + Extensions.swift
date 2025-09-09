//
//  TimetableMenuWeekDaysListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 08.07.2025.
//

import UIKit

// MARK: - ITimetableMenuWeekDaysListViewModel
extension TimetableMenuWeekDaysListViewModel: ITimetableMenuWeekDaysListViewModel {
    
    func dayItem(index: Int)-> DayModel {
        return days[index]
    }
    
    func dayItemsCount()-> Int {
        return days.count
    }
    
    func resetData() {
        days = []
        setUpData()
    }
    
    func updateData(id: String, date: String, owner: String, week: WeekModel) {
        self.id = id
        self.currentDate = date
        self.owner = owner
        self.week = week
        setUpWeekData(week: week)
    }
    
    func setUpData() {
        setUpWeekData(week: week)
    }
    
    func setUpWeekData(week: WeekModel) {
        let keys = week.dayNames.keys.sorted { dateManager.compareDates(date1: $0, date2: $1) == .orderedAscending }
        self.days = keys.map({ DayModel(name: "Неделя \(week.id)", date: $0, dayOfWeek: dateManager.getCurrentDayOfWeek(date: $0), info: "Загрузка...")})
        getTimetableInfo()
    }
    
    func getTimetableInfo() {
        let dispatchGroup = DispatchGroup()
        for day in days {
            dispatchGroup.enter()
            timetableService.getTimeTableDay(id: id, date: day.date, owner: owner) { [weak self] result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let timetable):
                    if !timetable.disciplines.isEmpty {
                        // просто расписание
                        let day = self?.days.first { $0.date == day.date }
                        let index = self?.days.firstIndex(of: day!)
                        let pairsCount = self?.getPairsCount(pairs: timetable.disciplines) ?? 0
                        // особые дни
                        let coursesCount = self?.getCoursesCount(pairs: timetable.disciplines) ?? 0
                        let testsCount = self?.getTestsCount(pairs: timetable.disciplines) ?? 0
                        let consCount = self?.getConsCount(pairs: timetable.disciplines) ?? 0
                        let examsCount = self?.getExamsCount(pairs: timetable.disciplines) ?? 0
                        let holidaysExisting = self?.checkHolidaysExisting(pairs: timetable.disciplines)
                        
                        if pairsCount > 0 {
                            self?.days[index!].info = "пар: \(self?.getPairsCount(pairs: timetable.disciplines) ?? 0)"
                        }
                        
                        if coursesCount > 0 {
                            self?.days[index!].info = coursesCount > 1 ? "курсовые" : "курсовая!"
                        }
                        
                        if testsCount > 0 {
                            self?.days[index!].info = testsCount > 1 ? "зачеты" : "зачет"
                        }
                        
                        if consCount > 0 {
                            self?.days[index!].info = "конс."
                        }
                        
                        if examsCount > 0 {
                            self?.days[index!].info = examsCount > 1 ? "экзамены!" : "экзамен!"
                        }
                        
                        if holidaysExisting ?? false {
                            self?.days[index!].info = "каникулы!"
                        }
                    } else {
                        if let day = self?.days.first(where: { $0.name == day.name }) {
                            if let index = self?.days.firstIndex(of: day) {
                                self?.days[index].info = "нет пар"
                            }
                        }
                    }
                case .failure(let error):
                    let day = self?.days.first { $0.name == day.name }
                    let index = self?.days.firstIndex(of: day!)
                    self?.days[index!].info = "нет пар"
                    self?.dataChangedHandler?()
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
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
                            
            uniqueTimes.insert(startTime)
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
    
    // проверка каникул
    func checkHolidaysExisting(pairs: [Discipline])-> Bool {
        
        for pair in pairs {
            if pair.name.contains("Каникулы") {
                return true
            }
        }
        return false
    }
    
    func chooseDay(index: Int) {
        let day = dayItem(index: index)
        if day.info.contains("экз") || day.info.contains("курс") {
            AudioPlayerClass.shared.playSound(sound: "danger", isPlaying: false)
        } else {
            AudioPlayerClass.shared.playSound(sound: "paper", isPlaying: false)
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    func timeTableColor(index: Int)-> UIColor {
        let day = days[index]
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
    
    func titleForNavigation()-> String {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return "Выберите день"
        case .informal:
            return "Выбери день"
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
