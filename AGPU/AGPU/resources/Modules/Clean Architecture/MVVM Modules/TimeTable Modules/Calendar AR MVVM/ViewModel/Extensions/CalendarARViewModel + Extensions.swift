//
//  CalendarARViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.08.2024.
//

import UIKit

// MARK: - ICalendarARViewModel
extension CalendarARViewModel: ICalendarARViewModel {
                
    func compareDates(date1: String, date2: Date)-> UIColor? {
        
        let date = dateManager.getDateFromString(str: date1, withTime: false)
        
        if let selectedDate = date, Calendar.current.isDate(date2, inSameDayAs: selectedDate) {
              return UIColor.systemGreen
        }
        return nil
    }
    
    func getTimetable(date: Date) {
        let formattedDate = getFormattedDate(date: date)
        service.getTimeTableDay(id: id, date: formattedDate, owner: owner) { result in
            switch result {
            case .success(let data):
                self.createImage(timetable: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createImage(timetable: TimeTable) {
        
        let recentGroup = UserDefaults.standard.string(forKey: "recentGroup") ?? "ВМ-ИВТ-2-1"
        let recentDate = UserDefaults.standard.string(forKey: "recentDate") ?? dateManager.getCurrentDate()
        
        let emptyTimetable = TimeTable(id: recentGroup, date: recentDate, disciplines: [])
        
        if !timetable.disciplines.isEmpty {
            do {
                let json = try JSONEncoder().encode(timetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    self.imageCreatedHandler?(image, timetable.date)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    self.imageCreatedHandler?(image, timetable.date)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getFormattedDate(date: Date)-> String {
        return dateManager.getFormattedDate(date: date)
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
    
    func registerImageCreatedHandler(block: @escaping(UIImage, String)->Void) {
        self.imageCreatedHandler = block
    }
}
