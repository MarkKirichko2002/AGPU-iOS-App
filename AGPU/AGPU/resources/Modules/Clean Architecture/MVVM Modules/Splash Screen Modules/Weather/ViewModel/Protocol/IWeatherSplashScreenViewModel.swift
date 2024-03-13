//
//  IWeatherSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 10.03.2024.
//

import WeatherKit

protocol IWeatherSplashScreenViewModel {
    func getWeather()
    func registerWeatherHandler(block: @escaping(Weather)->Void)
}
