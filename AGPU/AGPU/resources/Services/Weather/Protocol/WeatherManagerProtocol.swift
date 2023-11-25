//
//  WeatherManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 25.11.2023.
//

import CoreLocation
import WeatherKit

protocol WeatherManagerProtocol {
    func getWeather(location: CLLocation, completion: @escaping(Weather)->Void)
    func formatWeather(weather: Weather)-> String
}
