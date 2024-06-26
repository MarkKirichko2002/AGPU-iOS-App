//
//  IRecentDatesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation

protocol IRecentDatesListViewModel {
    func datesCount()-> Int
    func dateItem(index: Int)-> String
    func getDates()
    func updateDates(dates: [String], _ index: Int, _ index2: Int)
    func loadDates()-> [String]
    func deleteDate(date: String)
    func registerDataChangedHandler(block: @escaping()->Void)
}
