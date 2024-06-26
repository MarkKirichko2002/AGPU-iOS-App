//
//  CalendarMultipleDatesViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

// MARK: - ICalendarMultipleDatesViewModel
extension CalendarMultipleDatesViewModel: ICalendarMultipleDatesViewModel {
    
    func selectDates(dates: UICalendarSelectionMultiDate) {
        let dates = dates.selectedDates.map({ dateManager.getFormattedDate(date: $0.date ?? Date())})
        if dates.count <= 7 {
            UserDefaults.saveArray(array: dates, key: "dates") {
                self.datesSelectedHandler?()
            }
        } else if dates.count > 7 {
            self.alertHandler?()
        }
    }
    
    func registerDatesSelectedHandler(block: @escaping() -> Void) {
        self.datesSelectedHandler = block
    }
    
    func registerAlertHandler(block: @escaping() -> Void) {
        self.alertHandler = block
    }
}
