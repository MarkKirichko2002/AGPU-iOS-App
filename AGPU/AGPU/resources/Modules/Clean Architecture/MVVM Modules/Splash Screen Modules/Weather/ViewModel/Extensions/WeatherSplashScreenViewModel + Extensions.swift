//
//  WeatherSplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 10.03.2024.
//

import WeatherKit

// MARK: - IWeatherSplashScreenViewModel
extension WeatherSplashScreenViewModel: IWeatherSplashScreenViewModel {
    
    func getWeather() {
        locationManager.getLocations()
        locationManager.registerLocationHandler { location in
            self.weatherManager.getWeather(location: location) { weather in
                self.weatherHandler?(weather)
            }
        }
    }
    
    func formatWeather(weather: Weather)-> String {
        let description = weatherManager.formatWeather(weather: weather)
        return description
    }
    
    func registerWeatherHandler(block: @escaping(Weather)->Void) {
        self.weatherHandler = block
    }
}
