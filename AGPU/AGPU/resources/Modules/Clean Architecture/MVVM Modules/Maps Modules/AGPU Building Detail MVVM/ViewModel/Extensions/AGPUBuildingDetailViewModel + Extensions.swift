//
//  AGPUBuildingDetailViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 30.11.2023.
//

import WeatherKit

// MARK: - AGPUBuildingDetailViewModelProtocol
extension AGPUBuildingDetailViewModel: AGPUBuildingDetailViewModelProtocol {
    
    func getWeather() {
        WeatherManager.shared.getWeather(location: location) { weather in
            self.weatherHandler?("Погода: \(WeatherManager.shared.formatWeather(weather: weather))")
        }
    }
    
    func registerWeatherHandler(block: @escaping(String)->Void) {
        self.weatherHandler = block
    }
}
