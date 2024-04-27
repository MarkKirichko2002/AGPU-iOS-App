//
//  IWeekDaysListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 17.03.2024.
//

import Foundation

protocol IWeekDaysListViewModel {
    func setUpDays()
    func getInfo()
    func getPairsCount(pairs: [Discipline])-> Int
    func registerDataChangedHandler(block: @escaping()->Void)
}
