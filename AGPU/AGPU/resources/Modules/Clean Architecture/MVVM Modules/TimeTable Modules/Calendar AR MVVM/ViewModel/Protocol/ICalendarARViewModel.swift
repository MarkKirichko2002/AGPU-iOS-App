//
//  ICalendarARViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 21.08.2024.
//

import UIKit

protocol ICalendarARViewModel {
    func compareDates(date1: String, date2: Date)-> UIColor?
    func getFormattedDate(date: Date)-> String
    func saveDate(date: String)
}
