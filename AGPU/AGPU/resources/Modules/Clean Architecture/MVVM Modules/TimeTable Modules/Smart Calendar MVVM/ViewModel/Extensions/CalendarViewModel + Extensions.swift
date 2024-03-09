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
        
        let date = dateManager.getDateFromString(str: date1)
        
        if let selectedDate = date, Calendar.current.isDate(date2, inSameDayAs: selectedDate) {
              return UIColor.systemBlue
        }
        return nil
    }
    
    func sendNotificationDataWasSelected(date: String) {
        NotificationCenter.default.post(name: Notification.Name("DateWasSelected"), object: date)
    }
}
