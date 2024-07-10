//
//  WeatherManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 25.11.2023.
//

import CoreLocation
import WeatherKit

protocol WeatherManagerProtocol {
    func getWeather(location: CLLocation) async throws -> Result<Weather, Error>
    func formatWeather(weather: Weather)-> String
}
