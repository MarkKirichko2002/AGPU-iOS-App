//
//  WeatherManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 25.11.2023.
//

import CoreLocation
import WeatherKit

extension WeatherManager: WeatherManagerProtocol {
        
    func getWeather(location: CLLocation, completion: @escaping(Weather)->Void) {
        Task {
            do {
                let result = try await service.weather(for: location)
                completion(result)
            } catch {
                print(error)
            }
        }
    }
    
    func formatWeather(weather: Weather)-> String {
        var formattedWeather = ""
        var condition = ""
        let temperature = weather.currentWeather.temperature
        switch weather.currentWeather.condition {
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
        formattedWeather = "\(temperature) " + condition
        return formattedWeather
    }
}
