//
//  CalendarDisciplineNameViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.04.2025.
//

import UIKit

// MARK: - ICalendarDisciplineNameViewModel
extension CalendarDisciplineNameViewModel: ICalendarDisciplineNameViewModel {
    
    func getFormattedDate(date: Date)-> String {
        return dateManager.getFormattedDate(date: date)
    }
    
    func compareDates(date1: String, date2: Date)-> UIColor? {
        
        let date = dateManager.getDateFromString(str: date1, withTime: false)
        
        if let selectedDate = date, Calendar.current.isDate(date2, inSameDayAs: selectedDate) {
              return UIColor.systemGreen
        }
        return nil
    }
    
    func checkTimetable(date: String, name: String) {
        service.getTimeTableDay(id: id, date: date, owner: owner) { result in
            switch result {
            case .success(let data):
                let disciplines = data.disciplines.filter { $0.name == name }
                if !disciplines.isEmpty {
                    self.alertHandler?(disciplines[0].name, date)
                } else {
                    self.alertHandler?("", date)
                }
                HapticsManager.shared.hapticFeedback()
            case .failure(let error):
                self.alertHandler?("", date)
                print(error.localizedDescription)
                HapticsManager.shared.hapticFeedback()
            }
        }
    }
    
    func makeDateComponents(date: String)-> DateComponents {
        return dateManager.makeDateComponents(date: date)
    }
    
    func registerAlertHandler(block: @escaping(String, String)->Void) {
        self.alertHandler = block
    }
}
