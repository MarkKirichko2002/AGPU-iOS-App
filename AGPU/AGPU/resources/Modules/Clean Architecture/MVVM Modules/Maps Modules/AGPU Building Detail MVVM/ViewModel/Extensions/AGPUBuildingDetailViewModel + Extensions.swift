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
        let group = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-2-1"
        let date = dateManager.getCurrentDate()
        timetableService.getTimeTableDay(groupId: group, date: date) { [weak self] result in
            switch result {
            case .success(let data):
                let pairs = data.disciplines
                let existing = self?.checkPairsExisting(pairs: pairs)
                self?.pairsHandler?("В данном корпусе сегодня \(existing ?? "")")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkPairsExisting(pairs: [Discipline])-> String {
        let currentBuilding = AGPUBuildings.buildings.first { $0.name == annotation.title! }
        for audience in currentBuilding!.audiences {
            for pair in pairs {
                if audience == pair.audienceID {
                    self.pairsColorHandler?(UIColor.systemGreen)
                    return "есть пары"
                }
            }
        }
        self.pairsColorHandler?(UIColor.systemGray)
        return "нет пар"
    }
    
    func getWeather() {
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        WeatherManager.shared.getWeather(location: location) { weather in
            self.weatherHandler?("Погода: \(WeatherManager.shared.formatWeather(weather: weather))")
        }
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
