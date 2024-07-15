//
//  ILocationWeatherDetailViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.02.2024.
//

import MapKit
import WeatherKit

protocol ILocationWeatherDetailViewModel {
    var currentWeather: CurrentWeatherTableViewCellViewModel? {get set}
    var hourlyWeather: [HourlyWeatherCollectionViewCellViewModel] {get set}
    var dailyWeather: [DailyWeatherTableViewCellViewModel] {get set}
    func getWeather(location: MKAnnotation)
    func setUpCurrentWeather(weather: Weather)
    func setUpHourlyWeather(weather: Weather)
    func setUpDailyWeather(weather: Weather)
    func refresh()
    func convertToCelsius()
    func convertToFahrenheit()
    func convertToCalvin()
    func formatCondition(weather: WeatherCondition)-> String
}
