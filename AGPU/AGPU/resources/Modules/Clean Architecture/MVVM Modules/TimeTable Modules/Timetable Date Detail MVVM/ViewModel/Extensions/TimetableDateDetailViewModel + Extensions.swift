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
        UserDefaults.standard.setValue(id, forKey: "recentGroup")
        UserDefaults.standard.setValue(date, forKey: "recentDate")
        UserDefaults.standard.setValue(owner, forKey: "recentOwner")
        timeTableService.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let data):
                self?.pairs = data.disciplines
                self?.allDisciplines = data.disciplines
                if !data.disciplines.isEmpty {
                    self?.setUpDisciplinesPseudonym()
                    self?.createImage()
                } else {
                    self?.createImage()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshTimetable() {
        self.type = .all
        self.currentBuilding = nil
        self.currentTime = nil
        self.subgroup = 0
        getTimeTableForDay()
    }
    
    func getTimeTableForSearch(id: String, owner: String) {
        UserDefaults.standard.setValue(id, forKey: "recentGroup")
        UserDefaults.standard.setValue(date, forKey: "recentDate")
        UserDefaults.standard.setValue(owner, forKey: "recentOwner")
        UserDefaults.standard.setValue(id, forKey: "group")
        self.type = .all
        self.id = id
        self.owner = owner
        timeTableService.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let data):
                self?.pairs = data.disciplines
                self?.allDisciplines = data.disciplines
                if !data.disciplines.isEmpty {
                    self?.setUpDisciplinesPseudonym()
                    self?.createImage()
                } else {
                    self?.createImage()
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
        
        self.currentBuilding = nil
        self.currentTime = nil
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
        setUpDisciplinesPseudonym()
        createImage()
    }
    
    func filterLeftedPairs(pairs: [Discipline])-> [Discipline] {
        
        var disciplines = [Discipline]()
        
        let currentDate = dateManager.getCurrentDate()
        let currentTime = dateManager.getCurrentTime(isFullFormat: true)
        
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
    
    func filterPairs(by subgroup: Int) {
        
        self.subgroup = subgroup
        
        if self.allDisciplines.isEmpty {
            self.allDisciplines = pairs
        }
        
        let filteredDisciplines = self.allDisciplines.filter { $0.subgroup == subgroup }
        
        self.type = filteredDisciplines.first?.type ?? .all
        
        self.pairs = filteredDisciplines
        
        setUpDisciplinesPseudonym()
        createImage()
    }
    
    func filterPairs(by building: AGPUBuildingModel) {
        self.currentBuilding = building
        self.currentTime = nil
        self.type = .all
        var disciplines = [Discipline]()
        guard let corp = currentBuilding else {return}
        for audience in corp.audiences {
            for pair in allDisciplines {
                if audience == pair.audienceID {
                    disciplines.append(pair)
                }
            }
        }
        self.pairs = disciplines.sorted { self.dateManager.compareTimes(time1: "\($0.time.components(separatedBy: "-")[0]):00", time2: "\($1.time.components(separatedBy: "-")[0]):00") == .orderedAscending}
        setUpDisciplinesPseudonym()
        createImage()
    }
    
    func filterPairs(by time: String) {
        self.currentTime = time
        self.currentBuilding = nil
        self.type = .all
        self.pairs = allDisciplines.filter({ $0.time == time })
        setUpDisciplinesPseudonym()
        createImage()
    }
    
    func setUpDisciplinesPseudonym() {
        pairs = timetablePseudonymManager.setUpTimetablePseudonyms(pairs: &pairs)
    }
    
    func createImage() {
        if !pairs.isEmpty {
            let timetable = TimeTable(id: id, date: date, disciplines: pairs)
            self.getImage(json: timetable) { image in
                let model = TimeTableDateModel(id: self.id, date: self.date, image: image, description: "\(self.formattedDate()) пары: \(self.getPairsCount())")
                self.model = TimeTableChangesModel(id: self.id, date: self.date, owner: self.owner, type: self.type, subgroup: self.subgroup, filteredPairs: self.pairs, allPairs: self.allDisciplines)
                self.image = image
                DispatchQueue.main.async {
                    self.timeTableHandler?(model)
                }
            }
        } else {
            let timetable = TimeTable(id: id, date: date, disciplines: pairs)
            self.getImage(json: timetable) { image in
                let model = TimeTableDateModel(id: self.id, date: self.date, image: image, description: "\(self.formattedDate()) нет пар")
                self.model = TimeTableChangesModel(id: self.id, date: self.date, owner: self.owner, type: self.type, subgroup: self.subgroup, filteredPairs: self.pairs, allPairs: self.allDisciplines)
                self.image = image
                DispatchQueue.main.async {
                    self.timeTableHandler?(model)
                }
            }
        }
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
    
    func getCommunicationStyle()-> CommunicationStyles {
        return settingsManager.getSavedCommunicationStyle()
    }
    
    func loadSavedMenuOptions()-> [MenuOptionModel] {
        return settingsManager.loadMenuOptions(category: menuCategoryScreens.timetableDate.rawValue)
    }
    
    func registerTimeTableHandler(block: @escaping (TimeTableDateModel) -> Void) {
        self.timeTableHandler = block
    }
}
