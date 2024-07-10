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
            Task {
                let result = try await WeatherManager.shared.getWeather(location: location)
                switch result {
                case .success(let data):
                    self.weatherHandler?(data)
                case .failure(let error):
                    print(error)
                }
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
