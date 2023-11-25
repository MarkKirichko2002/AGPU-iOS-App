//
//  WeatherManager.swift
//  AGPU
//
//  Created by Марк Киричко on 25.11.2023.
//

import WeatherKit

class WeatherManager {
    
    let service = WeatherService.shared
    
    static let shared = WeatherManager()
    
}
