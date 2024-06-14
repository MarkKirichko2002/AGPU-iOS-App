//
//  TimetableDateDetailViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2024.
//

import UIKit

// MARK: - TimetableDateDetailViewModel
extension TimetableDateDetailViewModel: ITimetableDateDetailViewModel {
    
    func getTimeTableForDay() {
        timeTableService.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let data):
                self?.pairs = data.disciplines
                self?.allDisciplines = data.disciplines
                if !data.disciplines.isEmpty {
                    self?.getImage(json: data) { image in
                        let model = TimeTableDateModel(id: data.id, date: self?.date ?? "", image: image, description: "\(self?.formattedDate() ?? "") пары: \(self?.getPairsCount() ?? 0)")
                        self?.image = image
                        self?.timeTableHandler?(model)
                    }
                } else {
                    self?.getImage(json: data) { image in
                        let model = TimeTableDateModel(id: data.id, date: self?.date ?? "", image: image, description: "\(self?.formattedDate() ?? "") нет пар")
                        self?.image = image
                        self?.timeTableHandler?(model)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTimeTableForSearch(id: String, owner: String) {
        self.type = .all
        self.id = id
        timeTableService.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let data):
                self?.pairs = data.disciplines
                self?.allDisciplines = data.disciplines
                if !data.disciplines.isEmpty {
                    self?.getImage(json: data) { image in
                        let model = TimeTableDateModel(id: data.id, date: self?.date ?? "", image: image, description: "\(self?.formattedDate() ?? "") пары: \(self?.getPairsCount() ?? 0)")
                        self?.image = image
                        self?.timeTableHandler?(model)
                    }
                } else {
                    self?.getImage(json: data) { image in
                        let model = TimeTableDateModel(id: data.id, date: self?.date ?? "", image: image, description: "\(self?.formattedDate() ?? "") нет пар")
                        self?.image = image
                        self?.timeTableHandler?(model)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
        
    func getImage(json: Codable, completion: @escaping(UIImage)->Void) {
        do {
            let json = try JSONEncoder().encode(json)
            self.timeTableService.getTimeTableDayImage(json: json) { image in
                completion(image)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getPairsCount()-> Int {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in pairs {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
    }
    
    func textColor()-> UIColor {
        if pairs.isEmpty {
            return .systemGray
        } else {
            return .systemGreen
        }
    }
    
    func filterPairs(type: PairType) {
        
        self.type = type
        
        if type == .all {
            
            if self.allDisciplines.isEmpty {
                self.allDisciplines = pairs
            }
            self.pairs = self.allDisciplines
           
        } else if type == .leftToday {
            
            let filteredDisciplines = self.filterLeftedPairs(pairs: self.allDisciplines)
            self.pairs = filteredDisciplines
            
        } else {
            
            if self.allDisciplines.isEmpty {
                self.allDisciplines = pairs
            }
            
            let filteredDisciplines = self.allDisciplines.filter { $0.type == type }
            self.pairs = filteredDisciplines
        }
        
        if !pairs.isEmpty {
            let timetable = TimeTable(id: id, date: date, disciplines: pairs)
            self.getImage(json: timetable) { image in
                let model = TimeTableDateModel(id: self.id, date: self.date, image: image, description: "\(self.formattedDate()) пары: \(self.getPairsCount())")
                self.image = image
                self.timeTableHandler?(model)
            }
        } else {
            let timetable = TimeTable(id: id, date: date, disciplines: pairs)
            self.getImage(json: timetable) { image in
                let model = TimeTableDateModel(id: self.id, date: self.date, image: image, description: "\(self.formattedDate()) нет пар")
                self.image = image
                self.timeTableHandler?(model)
            }
        }
    }
    
    func filterLeftedPairs(pairs: [Discipline])-> [Discipline] {
        
        var disciplines = [Discipline]()
        
        let currentDate = dateManager.getCurrentDate()
        let currentTime = dateManager.getCurrentTime()
        
        for pair in pairs {
            
            let pairEndTime = "\(pair.time.components(separatedBy: "-")[1]):00"
            
            let timetableDate = date
            
            let compareDate = dateManager.compareDates(date1: timetableDate, date2: currentDate)
            let compareTime = dateManager.compareTimes(time1: pairEndTime, time2: currentTime)
            
            // прошлый день
            if compareDate == .orderedAscending {
                return disciplines
            }
            
            // время больше и тот же день
            if compareTime == .orderedDescending && compareDate == .orderedSame {
                disciplines.append(pair)
            }
            
            // следующий день
            if compareDate == .orderedDescending {
                return allDisciplines
            }
        }
        
        return disciplines
    }
    
    func formattedDate()-> String {
        let date = "\(dateManager.getCurrentDayOfWeek(date: date)) \(date)"
        return date
    }
    
    func saveImageToList() {
        let model = ImageModel()
        model.date = self.date
        model.image = image?.jpegData(compressionQuality: 1.0) ?? Data()
        self.realmManager.saveImage(image: model)
    }
    
    func registerTimeTableHandler(block: @escaping (TimeTableDateModel) -> Void) {
        self.timeTableHandler = block
    }
}
