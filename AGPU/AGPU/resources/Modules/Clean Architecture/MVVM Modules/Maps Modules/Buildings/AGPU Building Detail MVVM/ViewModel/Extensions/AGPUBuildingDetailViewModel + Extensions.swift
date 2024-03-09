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
        WeatherManager.shared.getWeather(location: location) { weather in
            self.weatherHandler?("Погода: \(WeatherManager.shared.formatWeather(weather: weather))")
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
        timetable.disciplines = disciplines
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
