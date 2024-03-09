//
//  CalendarViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import UIKit

protocol CalendarViewModelProtocol {
    func compareDates(date1: String, date2: Date)-> UIColor?
    func sendNotificationDataWasSelected(date: String)
}
