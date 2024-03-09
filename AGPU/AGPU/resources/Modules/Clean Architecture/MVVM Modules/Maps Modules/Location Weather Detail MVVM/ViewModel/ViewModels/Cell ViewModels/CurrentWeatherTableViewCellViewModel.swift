//
//  CurrentWeatherTableViewCellViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.02.2024.
//

import Foundation

class CurrentWeatherTableViewCellViewModel {
    
    var icon: String
    var location: String
    var temperature: Int
    var condition: String
    var maxTemperature: Int
    var minTemperature: Int
    
    init(icon: String, location: String, temperature: Int, condition: String, maxTemperature: Int, minTemperature: Int) {
        self.icon = icon
        self.location = location
        self.temperature = temperature
        self.condition = condition
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
    }
}
