//
//  TimeTableDatesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation
import UIKit

// MARK: - ITimeTableDatesListViewModel
extension TimeTableDatesListViewModel: ITimeTableDatesListViewModel {
    
    func pairAtSection(section: Int, index: Int)-> Discipline {
        return timetable[section].disciplines[index]
    }
    
    func numberOfTimetableSections()-> Int {
        return timetable.count
    }
    
    func numberOfPairsInSection(section: Int)-> Int {
        return timetable[section].disciplines.count
    }
    
    func titleForHeaderInSection(section: Int)-> String {
        return "\(dateManager.getCurrentDayOfWeek(date: timetable[section].date)) \(timetable[section].date)"
    }
    
    func getData() {
        
        let dispatchGroup = DispatchGroup()
        
        for date in dates {
            
            dispatchGroup.enter()
            
            service.getTimeTableDay(id: id, date: date, owner: owner) { result in
                defer { dispatchGroup.leave()}
                switch result {
                case .success(let data):
                    let model = TimeTableDayModel(id: self.id, owner: self.owner, date: date, disciplines: data.disciplines)
                    if !data.disciplines.isEmpty {
                        self.timetable.append(model)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.timetable.sort { $0.date < $1.date }
            self.dataChangedHandler?()
        }
    }
    
    func datesString()-> String {
        if dates.count > 1 && dates.count < 5 {
            return "Расписание на \(dates.count) дня"
        } else if dates.count >= 5 {
            return "Расписание на \(dates.count) дней"
        } else if dates.isEmpty {
            return "Расписание"
        } else {
            return "Расписание на \(dates.count) день"
        }
    }
    
    func saveImage(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let model = ImageModel()
            model.date = self.dateManager.getCurrentDate()
            model.image = imageData
            self.realmManager.saveImage(image: model)
        }
    }
    
    func createImage(completion: @escaping(UIImage)->Void) {
        let emptyTimetable = [TimeTable(id: id, date: dateManager.getCurrentDate(), disciplines: [])]
        if !self.timetable.isEmpty {
            do {
                let data = timetable.map {TimeTable(id: $0.id, date: $0.date, disciplines: $0.disciplines)}
                let json = try JSONEncoder().encode(data)
                service.getTimeTableWeekImage(json: json) { image in
                    completion(image)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                service.getTimeTableWeekImage(json: json) { image in
                    completion(image)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func registerDataChangedHandler(block: @escaping()-> Void) {
        self.dataChangedHandler = block
    }
}
