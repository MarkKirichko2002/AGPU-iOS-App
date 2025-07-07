//
//  TimetableARViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 08.05.2025.
//

import Foundation

// MARK: - TimeTableSearchListTableViewControllerDelegate
extension TimetableARViewController: TimeTableSearchListTableViewControllerDelegate {
    
    func itemWasSelected(result: SearchTimetableModel) {
        id = result.name
        owner = result.owner
        if currentWeek.id != 0 {
            getTimetable(week: currentWeek)
        } else {
            getTimetable(date: date)
        }
    }
}

// MARK: - NearBuildingViewControllerDelegate
extension TimetableARViewController: NearBuildingViewControllerDelegate {
    
    func audienceSelected(audience: String) {
        id = audience
        owner = "CLASSROOM"
        if currentWeek.id != 0 {
            getTimetable(week: currentWeek)
        } else {
            getTimetable(date: date)
        }
    }
}

// MARK: - AllGroupsListTableViewControllerDelegate
extension TimetableARViewController: AllGroupsListTableViewControllerDelegate {
    
    func groupWasSelected(group: String) {
        id = group
        owner = "GROUP"
        if currentWeek.id != 0 {
            getTimetable(week: currentWeek)
        } else {
            getTimetable(date: date)
        }
    }
}

// MARK: - DepartmentsListTableViewControllerDelegate
extension TimetableARViewController: DepartmentsListTableViewControllerDelegate {
    
    func teacherSelected(teacher: String) {
        id = teacher
        owner = "TEACHER"
        if currentWeek.id != 0 {
            getTimetable(week: currentWeek)
        } else {
            getTimetable(date: date)
        }
    }
}

// MARK: - CorpsListTableViewControllerDelegate
extension TimetableARViewController: CorpsListTableViewControllerDelegate {
    
    func audienceWasSelected(audience: String) {
        id = audience
        owner = "CLASSROOM"
        if currentWeek.id != 0 {
            getTimetable(week: currentWeek)
        } else {
            getTimetable(date: date)
        }
    }
}

// MARK: - TimeTableFavouriteItemsListTableViewControllerDelegate
extension TimetableARViewController: TimeTableFavouriteItemsListTableViewControllerDelegate {
    
    func WasSelected(result: SearchTimetableModel) {
        id = result.name
        owner = result.owner
        if currentWeek.id != 0 {
            getTimetable(week: currentWeek)
        } else {
            getTimetable(date: date)
        }
    }
}

// MARK: - CalendarARViewControllerDelegate
extension TimetableARViewController: CalendarARViewControllerDelegate {
    
    func dateWasSelected(date: String) {
        self.date = date
        self.dayType = .near
        isDay = true
        self.currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
        getTimetable(date: date)
    }
}

// MARK: - TimeTableDayListTableViewController
extension TimetableARViewController: DaysListTableViewControllerDelegate {
    
    func dayTypeSelected(type: DayType) {
        self.dayType = type
        switch dayType {
        case .near:
            currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
            isDay = true
        case .week:
            isDay = true
        case .selected:
            currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
            isDay = true
        case .recent:
            currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
            isDay = true
        }
    }
    
    func weekSelected(week: WeekModel) {
        isDay = true
        self.currentWeek = week
    }
    
    func datesSelected(dates: [String]) {
        isDay = true
        self.dates = dates
    }
    
    func dateSelected(date: String) {
        isDay = true
        self.date = date
        updateData()
    }
    
    func updateData() {
        switch dayType {
        case .near:
            currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
            getTimetable(date: date)
        case .week:
            getTimetable(date: date)
        case .selected:
            currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
            getTimetable(date: date)
        case .recent:
            currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
            getTimetable(date: date)
        }
    }
}

// MARK: - AllWeeksListTableViewControllerDelegate
extension TimetableARViewController: AllWeeksListTableViewControllerDelegate {
    
    func weekWasSelected(week: WeekModel) {
        date = week.from
        isDay = false
        dayType = .week
        getTimetable(week: week)
    }
}
