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
            self.alertHandler?(createAlertMessage().0, createAlertMessage().1)
        } else if formattedDates.count > 7 {
            self.alertHandler?(createSecondAlertMessage(count: formattedDates.count).0, createSecondAlertMessage(count: formattedDates.count).1)
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
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Даты не выбраны!", !name.isEmpty ? "\(name) выберите хотя бы одну дату" : "Выберите хотя бы одну дату")
        case .informal:
            return ("Даты не выбраны!", !name.isEmpty ? "\(name) выбери хотя бы одну" : "Выбери хотя бы одну")
        }
    }
    
    func createSecondAlertMessage(count: Int)-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Выбрано много дат!", !name.isEmpty ? "\(name) вы выбрали \(count) дат выберите не больше 7" : "Вы выбрали \(count) дат выберите не больше 7")
        case .informal:
            return ("Выбрано много дат!", !name.isEmpty ? "\(name) у тебя выбрано \(count) дат выбери не больше 7" : "У тебя выбрано \(count) дат выбери не больше 7")
        }
    }
    
    func titleForNavigation()-> String {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return "Выберите даты"
        case .informal:
            return "Выбери даты"
        }
    }
    
    func makeDateComponents(date: String)-> DateComponents {
        return dateManager.makeDateComponents(date: date)
    }
    
    func registerDatesSelectedHandler(block: @escaping()-> Void) {
        self.datesSelectedHandler = block
    }
    
    func registerAlertHandler(block: @escaping(String, String)-> Void) {
        self.alertHandler = block
    }
}
