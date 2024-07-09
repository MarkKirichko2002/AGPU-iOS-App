//
//  WeatherChangesModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.07.2024.
//

import WeatherKit

struct WeatherChangesModel: Codable {
    let date: String
    let weather: Weather
}
