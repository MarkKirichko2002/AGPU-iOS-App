//
//  ITimetableMenuWeekDaysListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.07.2025.
//

import UIKit

protocol ITimetableMenuWeekDaysListViewModel {
    func dayItem(index: Int)-> DayModel
    func dayItemsCount()-> Int
    func setUpData()
    func getTimetableInfo()
    func getPairsCount(pairs: [Discipline])-> Int
    func getCoursesCount(pairs: [Discipline])-> Int
    func getTestsCount(pairs: [Discipline])-> Int
    func getConsCount(pairs: [Discipline])-> Int
    func getExamsCount(pairs: [Discipline])-> Int
    func checkHolidaysExisting(pairs: [Discipline])-> Bool
    func chooseDay(index: Int)
    func timeTableColor(index: Int)-> UIColor
    func registerDataChangedHandler(block: @escaping()->Void)
}
