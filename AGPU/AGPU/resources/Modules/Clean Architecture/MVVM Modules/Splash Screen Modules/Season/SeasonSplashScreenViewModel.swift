//
//  SeasonSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2024.
//

import Foundation

final class SeasonSplashScreenViewModel {
    
    // MARK: - сервисы
    let dateManager = DateManager()
    
    var seasonHandler: ((String, String)->Void)?
    
}
