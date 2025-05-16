//
//  AGPUBuildingDetailViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 30.11.2023.
//

import WeatherKit
import Foundation
import MapKit
import UIKit

// MARK: - AGPUBuildingDetailViewModelProtocol
extension AGPUBuildingDetailViewModel: AGPUBuildingDetailViewModelProtocol {
    
    func getTimetable() {
        let date = dateManager.getCurrentDate()
        timetableService.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let data):
                let pairs = data.disciplines
                let existing = self?.checkPairsExisting(pairs: pairs)
                self?.pairsHandler?("В данном корпусе сегодня \(existing ?? "")")
                self?.disciplines = data.disciplines
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getWeather() {
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        Task {
            let result = try await WeatherManager.shared.getWeather(location: location)
            switch result {
            case .success(let data):
                self.weatherHandler?("Погода: \(WeatherManager.shared.formatWeather(weather: data))")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPairsCount(pairs: [Discipline])-> Int {
        var uniqueTimes: Set<String> = Set()
        let currentBuilding = AGPUBuildings.buildings.first { $0.name == annotation.title! }
        for audience in currentBuilding!.audiences {
            for pair in pairs {
                if audience == pair.audienceID {
                    let times = pair.time.components(separatedBy: "-")
                    let startTime = times[0]
                    uniqueTimes.insert(startTime)
                }
            }
        }
        return uniqueTimes.count
    }
    
    func getTimeTableForBuilding(pairs: [Discipline])-> TimeTable {
        var timetable = TimeTable(id: id, date: dateManager.getCurrentDate(), disciplines: [])
        var disciplines = [Discipline]()
        let currentBuilding = AGPUBuildings.buildings.first { $0.name == annotation.title! }
        for audience in currentBuilding!.audiences {
            for pair in pairs {
                if audience == pair.audienceID {
                    disciplines.append(pair)
                }
            }
        }
        timetable.disciplines = disciplines.sorted { dateManager.compareTimes(time1: "\($0.time.components(separatedBy: "-")[0]):00", time2: "\($1.time.components(separatedBy: "-")[0]):00") == .orderedAscending}
        return timetable
    }
    
    func checkPairsExisting(pairs: [Discipline])-> String {
        let currentBuilding = AGPUBuildings.buildings.first { $0.name == annotation.title! }
        for audience in currentBuilding!.audiences {
            for pair in pairs {
                if audience == pair.audienceID {
                    self.pairsColorHandler?(UIColor.systemGreen)
                    return "есть пары: \(getPairsCount(pairs: pairs))"
                }
            }
        }
        self.pairsColorHandler?(UIColor.systemGray)
        return "нет пар"
    }
    
    func makeAudenciesList()-> [String] {
        
        var text = annotation.subtitle!!
        
        if text.contains("Аудитории: ") {
            for character in "Аудитории: " {
                let index = text.startIndex
                text.remove(at: index)
            }
        }
        
        let arr = text.components(separatedBy: ", ")
        return arr
    }
    
    func saveLocation(annotaion: MKAnnotation) {
        let model = RecentBuildingModel(name: annotation.title!!, info: annotation.subtitle!!, coordinates: [annotation.coordinate.latitude, annotation.coordinate.longitude])
        UserDefaults.saveData(object: model, key: "last location") {}
    }
    
    func registerWeatherHandler(block: @escaping(String)->Void) {
        self.weatherHandler = block
    }
    
    func registerPairsHandler(block: @escaping(String)->Void) {
        self.pairsHandler = block
    }
    
    func registerPairsColorHandler(block: @escaping(UIColor)->Void) {
        self.pairsColorHandler = block
    }
}
