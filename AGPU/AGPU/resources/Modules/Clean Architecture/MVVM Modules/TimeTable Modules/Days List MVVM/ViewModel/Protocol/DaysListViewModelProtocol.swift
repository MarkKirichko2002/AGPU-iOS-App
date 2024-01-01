//
//  DaysListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import UIKit

protocol DaysListViewModelProtocol {
    func setUpData()
    func getTimetableInfo()
    func getPairsCount(pairs: [Discipline])-> Int
    func getCoursesCount(pairs: [Discipline])-> Int
    func getTestsCount(pairs: [Discipline])-> Int
    func getConsCount(pairs: [Discipline])-> Int
    func getExamsCount(pairs: [Discipline])-> Int
    func chooseDay(index: Int)
    func timeTableColor(index: Int)-> UIColor
    func registerDataChangedHandler(block: @escaping()->Void)
}
