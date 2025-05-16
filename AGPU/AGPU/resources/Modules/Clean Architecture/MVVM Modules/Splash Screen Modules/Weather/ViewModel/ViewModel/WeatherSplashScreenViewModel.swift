//
//  WeatherSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 10.03.2024.
//

import WeatherKit

final class WeatherSplashScreenViewModel {
    
    var weatherHandler: ((Weather)->Void)?
    
    // MARK: - сервисы
    let locationManager = LocationManager()
    let weatherManager = WeatherManager()
    
}
