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
        DaysList.days[0].date = currentDate
        DaysList.days[1].date = DateManager().nextDay(date: currentDate)
        DaysList.days[2].date = DateManager().previousDay(date: currentDate)
        getTimetableInfo()
    }
    
    func getTimetableInfo() {
        for day in DaysList.days {
            timetableService.getTimeTableDay(groupId: group, date: day.date) { [weak self] result in
                switch result {
                case .success(let timetable):
                    if !timetable.disciplines.isEmpty {
                        let day = DaysList.days.first { $0.date == day.date }
                        let index = DaysList.days.firstIndex(of: day!)
                        DaysList.days[index!].info = "есть пары"
                        self?.dataChangedHandler?()
                    } else {
                        let day = DaysList.days.first { $0.date == day.date }
                        let index = DaysList.days.firstIndex(of: day!)
                        DaysList.days[index!].info = "нет пар"
                        self?.dataChangedHandler?()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func chooseDay(index: Int) {
        let day = DaysList.days[index]
        NotificationCenter.default.post(name: Notification.Name("DateWasSelected"), object: day.date)
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
