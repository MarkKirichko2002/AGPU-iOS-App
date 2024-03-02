//
//  LocationDetailWeatherViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.02.2024.
//

import MapKit
import Combine
import WeatherKit

class LocationWeatherDetailViewModel: ILocationWeatherDetailViewModel {
    
    @Published var isFetched: Bool = false
    
    private let locationManager = LocationManager()
    private let weatherService = WeatherManager()
    private let dateManager = DateManager()
    
    var currentWeather: CurrentWeatherTableViewCellViewModel?
    var hourlyWeather = [HourlyWeatherCollectionViewCellViewModel]()
    var dailyWeather = [DailyWeatherTableViewCellViewModel]()
    
    var annotation: MKAnnotation
    var weather: Weather?
    
    // MARK: - Init
    init(annotation: MKAnnotation) {
        self.annotation = annotation
    }
    
    func getWeather() {
        self.getWeather(location: annotation)
    }
    
    func getWeather(location: MKAnnotation) {
        hourlyWeather = []
        dailyWeather = []
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.weatherService.getWeather(location: location) { weather in
            // текущая погода
            self.setUpCurrentWeather(weather: weather)
            // погода по часам
            self.setUpHourlyWeather(weather: weather)
            // погода на 5 дней
            self.setUpDailyWeather(weather: weather)
            self.weather = weather
            self.isFetched.toggle()
        }
    }
    
    func setUpCurrentWeather(weather: Weather) {
        let currentWeatherModel = CurrentWeatherTableViewCellViewModel(icon: weather.currentWeather.symbolName, location: annotation.title!!, temperature: Int(weather.currentWeather.temperature.value), condition: formatCondition(weather: weather.currentWeather.condition), maxTemperature: Int(weather.dailyForecast[0].highTemperature.value), minTemperature: Int(weather.dailyForecast[0].lowTemperature.value))
        self.currentWeather = currentWeatherModel
    }
    
    func setUpHourlyWeather(weather: Weather) {
        var h = Calendar.current.component(.hour, from: weather.currentWeather.date)
        for i in 0...24 {
            h += 1
            let hour = Calendar.current.component(.hour, from: weather.hourlyForecast[h].date)
            let hourlyWeatherModel = HourlyWeatherCollectionViewCellViewModel(hour: hour, icon: weather.hourlyForecast.forecast[hour].symbolName, temperature: Int(weather.hourlyForecast.forecast[hour].temperature.value))
            hourlyWeather.append(hourlyWeatherModel)
        }
    }
    
    func setUpDailyWeather(weather: Weather) {
        for i in 0...4 {
            let day = Calendar.current.component(.weekday, from: weather.dailyForecast[i].date)
            let dailyWeatherModel = DailyWeatherTableViewCellViewModel(dayOfWeek: "\(dateManager.getCurrentDayOfWeek(day: day - 1))", weatherIcon: weather.dailyForecast[i].symbolName, minTemperature: Int(weather.dailyForecast[i].lowTemperature.value), maxTemperature: Int(weather.dailyForecast[i].highTemperature.value))
            dailyWeather.append(dailyWeatherModel)
        }
    }
    
    func refresh() {
        getWeather()
    }
    
    func convertToCelsius() {
        guard let weather = weather else {return}
        currentWeather = nil
        hourlyWeather = []
        dailyWeather = []
        setUpCurrentWeather(weather: weather)
        setUpHourlyWeather(weather: weather)
        setUpDailyWeather(weather: weather)
        self.isFetched.toggle()
    }
    
    func convertToFahrenheit() {
        guard let weather = weather else {return}
        currentWeather = nil
        hourlyWeather = []
        dailyWeather = []
        setUpCurrentWeather(weather: weather)
        setUpHourlyWeather(weather: weather)
        setUpDailyWeather(weather: weather)
        // текущая погода
        currentWeather?.temperature = (currentWeather?.temperature ?? 0 * 9/5) + 32
        currentWeather?.maxTemperature = (currentWeather?.maxTemperature ?? 0 * 9/5) + 32
        currentWeather?.minTemperature = (currentWeather?.minTemperature ?? 0 * 9/5) + 32
        // погода по часам
        hourlyWeather.forEach { item in
            item.temperature = (item.temperature * 9/5) + 32
        }
        // погода на 5 дней
        dailyWeather.forEach { day in
            day.maxTemperature = (day.maxTemperature * 9/5) + 32
            day.minTemperature = (day.minTemperature * 9/5) + 32
        }
        self.isFetched.toggle()
    }
    
    func convertToCalvin() {
        guard let weather = weather else {return}
        currentWeather = nil
        hourlyWeather = []
        dailyWeather = []
        setUpCurrentWeather(weather: weather)
        setUpHourlyWeather(weather: weather)
        setUpDailyWeather(weather: weather)
        // текущая погода
        currentWeather?.temperature = (currentWeather?.temperature ?? 0) + 273
        currentWeather?.maxTemperature = (currentWeather?.maxTemperature ?? 0) + 273
        currentWeather?.minTemperature = (currentWeather?.minTemperature ?? 0) + 273
        // погода по часам
        hourlyWeather.forEach { item in
            item.temperature = item.temperature + 273
        }
        // погода на 5 дней
        dailyWeather.forEach { day in
            day.maxTemperature = day.maxTemperature + 273
            day.minTemperature = day.minTemperature + 273
        }
        self.isFetched.toggle()
    }
    
    func formatCondition(weather: WeatherCondition)-> String {
        var condition = ""
        switch weather {
        case .blizzard:
            condition =  "Метель"
        case .blowingDust:
            condition = "Пыльный ветер"
        case .blowingSnow:
            condition = "Метель с поземкой"
        case .breezy:
            condition = "Ветрено"
        case .clear:
            condition = "Ясно"
        case .cloudy:
            condition = "Облачно"
        case .drizzle:
            condition = "Изморось"
        case .flurries:
            condition =  "Снежные заряды"
        case .foggy:
            condition = "Туманно"
        case .freezingDrizzle:
            condition = "Замерзающая морось"
        case .freezingRain:
            condition = "Ледяной дождь"
        case .frigid:
            condition = "Морозно"
        case .hail:
            condition = "Град"
        case .haze:
            condition = "Мгла"
        case .heavyRain:
            condition = "Сильный дождь"
        case .heavySnow:
            condition = "Сильный снег"
        case .hot:
            condition = "Жарко"
        case .hurricane:
            condition = "Ураган"
        case .isolatedThunderstorms:
            condition = "Местами грозы"
        case .mostlyClear:
            condition = "Преимущественно ясно"
        case .mostlyCloudy:
            condition = "Преимущественно облачно"
        case .partlyCloudy:
            condition = "Переменная облачность"
        case .rain:
            condition = "Дождь"
        case .scatteredThunderstorms:
            condition = "Рассеянные грозы"
        case .sleet:
            condition = "Мокрый снег"
        case .smoky:
            condition = "Туман от дыма"
        case .snow:
            condition = "Снег"
        case .strongStorms:
            condition = "Сильные бури"
        case .sunFlurries:
            condition = "Снежные продувки"
        case .sunShowers:
            condition = "Солнечные ливни"
        case .thunderstorms:
            condition = "Грозы"
        case .tropicalStorm:
            condition = "Тропический шторм"
        case .windy:
            condition = "Ветрено"
        case .wintryMix:
            condition = "Зимняя смесь"
        @unknown default:
            break
        }
        return condition
    }
}
