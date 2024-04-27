//
//  WeekDaysListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 17.03.2024.
//

import UIKit

// MARK: - IWeekDaysListViewModel
extension WeekDaysListViewModel: IWeekDaysListViewModel {
    
    func setUpDays() {
        days = timetable.enumerated().map { (index: Int, date: TimeTable) -> DayModel in
            let day = week.dayNames[date.date]!
            let date = timetable[index].date
            let model = DayModel(name: "", date: date, dayOfWeek: day, info: "загрузка...")
            return model
        }
        getInfo()
    }
    
    func getInfo() {
        let dispatchGroup = DispatchGroup()
        if !days.isEmpty {
            for i in 0...days.count - 1 {
                dispatchGroup.enter()
                service.getTimeTableDay(id: self.id, date: days[i].date, owner: self.owner) { [weak self] result in
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let data):
                        if !data.disciplines.isEmpty {
                            self?.days[i].info = "пар: \(self?.getPairsCount(pairs: data.disciplines) ?? 0)"
                        } else {
                            self?.days[i].info = "нет пар"
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
    }
    
    func getPairsCount(pairs: [Discipline])-> Int {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in pairs {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
                            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
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
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
