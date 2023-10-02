//
//  DaysListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import Foundation

// MARK: - DaysListViewModelProtocol
extension DaysListViewModel: DaysListViewModelProtocol {
    
    func setUpData() {
        
        DaysList.days[0].date = dateManager.getCurrentDate()
        DaysList.days[1].date = currentDate
        DaysList.days[2].date = dateManager.nextDay(date: currentDate)
        DaysList.days[3].date = dateManager.previousDay(date: currentDate)
        
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
                        let day = DaysList.days.first { $0.name == day.name }
                        let index = DaysList.days.firstIndex(of: day!)
                        DaysList.days[index!].info = "есть пары"
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
    
    func chooseDay(index: Int) {
        let day = DaysList.days[index]
        NotificationCenter.default.post(name: Notification.Name("DateWasSelected"), object: day.date)
        HapticsManager.shared.hapticFeedback()
    }
    
    func checkDisciplinesExistence(index: Int)-> Bool {
        let day = DaysList.days[index]
        if day.info == "есть пары" {
            return true
        } else {
            return false
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
