//
//  RandomSplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.04.2024.
//

import UIKit

// MARK: - RandomSplashScreenViewModel
extension RandomSplashScreenViewModel: IRandomSplashScreenViewModel {
    
    func generateRandomScreen()-> UIViewController {
        let randomScreen = SplashScreenOptions.allCases.randomElement()!
        let regularVC = RegularSplashScreenViewController(animation:  AnimationClass(), icon: "АГПУ", text: "ФГБОУ ВО «АГПУ»", width: 160, height: 160)
        let facultyVC = SelectedFacultySplashScreenViewController(animation: AnimationClass())
        let newYearVC = RegularSplashScreenViewController(animation:  AnimationClass(), icon: "новый год", text: "ФГБОУ ВО «АГПУ»", width: 160, height: 160)
        let weatherVC = WeatherSplashScreenViewController(animation: AnimationClass())
        let newsVC = NewsSplashScreenViewController(animation: AnimationClass())
        let timetableVC = TimeTableSplashScreenViewController(animation: AnimationClass())
        let customVC = CustomSplashScreenViewController(animation: AnimationClass())
        let tabBarVC = AGPUTabBarController()
        switch randomScreen {
        case .regular:
            return regularVC
        case .faculty:
            return facultyVC
        case .newyear:
            return newYearVC
        case .weather:
            return weatherVC
        case .news:
            return newsVC
        case .timetable:
            return timetableVC
        case .corps:
            return BuildingSplashScreenViewController(animation: AnimationClass())
        case .technopark:
            return RegularSplashScreenViewController(animation: AnimationClass(), icon: "technopark", text: "Технопарк", width: 160, height: 160)
        case .quantorium:
            return RegularSplashScreenViewController(animation: AnimationClass(), icon: "кванториум", text: "Кванториум", width: 160, height: 160)
        case .season:
            return SeasonSplashScreenViewController(animation: AnimationClass())
        case .halloween:
            return RegularSplashScreenViewController(animation: AnimationClass(), icon: "pumpkin", text: "Хэллоуин", width: 90, height: 90)
        case .additionalTab:
            return AdditionalTabSplashScreenViewController(animation: AnimationClass())
        case .custom:
            return customVC
        case .random:
            return regularVC
        case .none:
            return tabBarVC
        }
    }
}
