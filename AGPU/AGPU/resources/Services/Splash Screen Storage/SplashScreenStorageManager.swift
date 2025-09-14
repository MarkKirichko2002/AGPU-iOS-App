//
//  SplashScreenStorageManager.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2025.
//

import UIKit

final class SplashScreenStorageManager {
    
    static let shared = SplashScreenStorageManager()
    
    func getSavedSplashScreen()-> UIViewController {
        let screen = UserDefaults.loadData(type: SplashScreenOptions.self, key: "splash option") ?? .regular
        return getSplashScreen(screen: screen)
    }
    
    func generateRandomScreen()-> UIViewController {
        let randomScreen = SplashScreenOptions.allCases.randomElement()!
        return getSplashScreen(screen: randomScreen)
    }
    
    func getSplashScreen(screen: SplashScreenOptions)-> UIViewController {
        let regularVC = RegularSplashScreenViewController(animation:  AnimationClass(), icon: "АГПУ", text: "ФГБОУ ВО «АГПУ»", width: 180, height: 180)
        let facultyVC = SelectedFacultySplashScreenViewController(animation: AnimationClass())
        let newYearVC = RegularSplashScreenViewController(animation:  AnimationClass(), icon: "новый год", text: "ФГБОУ ВО «АГПУ»", width: 180, height: 180)
        let weatherVC = WeatherSplashScreenViewController(animation: AnimationClass())
        let newsVC = NewsSplashScreenViewController(animation: AnimationClass())
        let timetableVC = TimeTableSplashScreenViewController(animation: AnimationClass())
        let customVC = CustomSplashScreenViewController(animation: AnimationClass())
        let randomVC = RandomSplashScreenViewController()
        let tabBarVC = AGPUTabBarController()
        let speechVC = SpeechRecognitionSplashScreenViewController()
        switch screen {
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
        case .speechRecognition:
            return speechVC
        case .random:
            return randomVC
        case .none:
            return tabBarVC
        }
    }
}
