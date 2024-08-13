//
//  SeasonSplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2024.
//

import Foundation

// MARK: - ISeasonSplashScreenViewModel
extension SeasonSplashScreenViewModel: ISeasonSplashScreenViewModel {
    
    func getSeason() {
        let month = dateManager.getCurrentMonth()
        switch month {
        case 12,1,2:
            seasonHandler?("winter", "Зима")
        case 3,4,5:
            seasonHandler?("cloud", "Весна")
        case 6,7,8:
            seasonHandler?("sun", "Лето")
        case 9,10,11:
            seasonHandler?("umbrella", "Осень")
        default:
            break
        }
    }
    
    func registerSeasonHandler(block: @escaping(String, String)->Void) {
        self.seasonHandler = block
    }
}
