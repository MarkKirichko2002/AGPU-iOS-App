//
//  DaysListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import UIKit

// MARK: - DaysListViewModelProtocol
extension DaysListViewModel: DaysListViewModelProtocol {
    
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
    
    func setUpData() {
        switch dayType {
        case .near:
            setUpNearDays()
        case .week:
            setUpWeekData(week: week)
        case .selected:
            setUpSelectedDays(dates: dates)
        case .recent:
            setUpRecentDays()
        }
    }
    
    func setUpNearDays() {
        let one = DayModel(name: DaysList.days[0].name, date: dateManager.getCurrentDate(), dayOfWeek: dateManager.getCurrentDayOfWeek(date: dateManager.getCurrentDate()), info: "Загрузка...")
        let two = DayModel(name: DaysList.days[1].name, date: currentDate, dayOfWeek: dateManager.getCurrentDayOfWeek(date: currentDate), info: "Загрузка...")
        let three = DayModel(name: DaysList.days[2].name, date: dateManager.nextDay(date: currentDate), dayOfWeek: dateManager.getCurrentDayOfWeek(date: dateManager.nextDay(date: currentDate)), info: "Загрузка...")
        let four = DayModel(name: DaysList.days[3].name, date: dateManager.previousDay(date: currentDate), dayOfWeek: dateManager.getCurrentDayOfWeek(date: dateManager.previousDay(date: currentDate)), info: "Загрузка...")
        self.days = [one, two, three, four]
        getTimetableInfo()
    }
    
    func setUpWeekData(week: WeekModel) {
        var keys = week.dayNames.keys.sorted { dateManager.compareDates(date1: $0, date2: $1) == .orderedAscending }
        let values =  week.dayNames.values
        if values.contains("Воскресенье") {
            if let index = keys.firstIndex(where: { week.dayNames[$0] == "Воскресенье" }) {
                keys.remove(at: index)
            }
        }
        self.days = keys.map({ DayModel(name: "Неделя \(week.id)", date: $0, dayOfWeek: dateManager.getCurrentDayOfWeek(date: $0), info: "Загрузка...")})
        getTimetableInfo()
    }
    
    func setUpSelectedDays(dates: [String]) {
        self.days = dates.map({ DayModel(name: "Календарь", date: $0, dayOfWeek: dateManager.getCurrentDayOfWeek(date: $0), info: "Загрузка...")})
        getTimetableInfo()
    }
    
    func setUpRecentDays() {
        let dates = UserDefaults.standard.array(forKey: "recent dates") as? [String] ?? []
        self.days = dates.map({ DayModel(name: "Календарь", date: $0, dayOfWeek: dateManager.getCurrentDayOfWeek(date: $0), info: "Загрузка...")})
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
                        let day = self?.days.first { $0.name == day.name }
                        let index = self?.days.firstIndex(of: day!)
                        self?.days[index!].info = "нет пар"
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
