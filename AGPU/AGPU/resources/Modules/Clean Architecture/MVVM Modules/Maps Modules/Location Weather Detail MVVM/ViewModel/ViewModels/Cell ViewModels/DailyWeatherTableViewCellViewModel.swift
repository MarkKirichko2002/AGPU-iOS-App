//
//  DailyWeatherTableViewCellViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.02.2024.
//

import Foundation

class DailyWeatherTableViewCellViewModel {
    
    var dayOfWeek: String
    var weatherIcon: String
    var minTemperature: Int
    var maxTemperature: Int
    
    init(dayOfWeek: String, weatherIcon: String, minTemperature: Int, maxTemperature: Int) {
        self.dayOfWeek = dayOfWeek
        self.weatherIcon = weatherIcon
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
    }
}

