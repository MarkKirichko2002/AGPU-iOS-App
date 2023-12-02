//
//  CathedraBuildingDetailViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.12.2023.
//

import WeatherKit
import Foundation
import MapKit

// MARK: - AGPUBuildingDetailViewModelProtocol
extension CathedraBuildingDetailViewModel: CathedraBuildingDetailViewModelProtocol {
    
    func getWeather() {
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        WeatherManager.shared.getWeather(location: location) { weather in
            self.weatherHandler?("Погода: \(WeatherManager.shared.formatWeather(weather: weather))")
        }
    }
    
    func registerWeatherHandler(block: @escaping(String)->Void) {
        self.weatherHandler = block
    }
}
