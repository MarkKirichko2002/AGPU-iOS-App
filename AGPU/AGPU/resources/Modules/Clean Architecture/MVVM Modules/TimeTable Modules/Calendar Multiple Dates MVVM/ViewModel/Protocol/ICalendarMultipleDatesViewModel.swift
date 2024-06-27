//
//  ICalendarMultipleDatesViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

protocol ICalendarMultipleDatesViewModel {
    func selectDates(dates: UICalendarSelectionMultiDate)
    func getDates(from selection: UICalendarSelectionMultiDate)-> [String]
    func saveDates(from selection: UICalendarSelectionMultiDate)
    func registerDatesSelectedHandler(block: @escaping() -> Void)
    func registerAlertHandler(block: @escaping(String, String)-> Void)
}
