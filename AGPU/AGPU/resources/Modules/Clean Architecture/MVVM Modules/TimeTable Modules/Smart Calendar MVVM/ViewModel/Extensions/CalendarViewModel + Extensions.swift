//
//  CalendarViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.09.2023.
//

import UIKit

// MARK: - CalendarViewModelProtocol
extension CalendarViewModel: CalendarViewModelProtocol {
                
    func compareDates(date1: String, date2: Date)-> UIColor? {
        
        let date = dateManager.getDateFromString(str: date1, withTime: false)
        
        if let selectedDate = date, Calendar.current.isDate(date2, inSameDayAs: selectedDate) {
              return UIColor.systemGreen
        }
        return nil
    }
    
    func saveDate(date: String) {
        var dates = UserDefaults.standard.array(forKey: "recent dates") as? [String] ?? []
        if !dates.contains(date) {
            dates.append(date)
            UserDefaults.saveArray(array: dates, key: "recent dates") {
                print("Saved")
            }
        }
    }
}
