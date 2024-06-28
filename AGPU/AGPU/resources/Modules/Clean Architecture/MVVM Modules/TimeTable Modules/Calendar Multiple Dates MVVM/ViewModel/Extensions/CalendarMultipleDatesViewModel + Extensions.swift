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
        let formattedDates = dates.selectedDates.map({ dateManager.getFormattedDate(date: $0.date ?? Date())})
        if formattedDates.count == 0 {
            self.alertHandler?("Даты не выбраны!", "выберите хотя бы одну дату")
        } else if formattedDates.count > 7 {
            self.alertHandler?("Выбрано много дат!", "вы выбрали \(formattedDates.count) дат выберите не больше 7")
        } else {
            self.saveDates(from: dates)
            self.datesSelectedHandler?()
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    func getDates(from selection: UICalendarSelectionMultiDate)-> [String] {
        let dates = selection.selectedDates.map({ dateManager.getFormattedDate(date: $0.date ?? Date())})
        return dates
    }
    
    func saveDates(from selection: UICalendarSelectionMultiDate) {
        let dates = selection.selectedDates.map({ dateManager.getFormattedDate(date: $0.date ?? Date())})
        UserDefaults.saveArray(array: dates, key: "recent dates") {
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func registerDatesSelectedHandler(block: @escaping() -> Void) {
        self.datesSelectedHandler = block
    }
    
    func registerAlertHandler(block: @escaping(String, String)-> Void) {
        self.alertHandler = block
    }
}
