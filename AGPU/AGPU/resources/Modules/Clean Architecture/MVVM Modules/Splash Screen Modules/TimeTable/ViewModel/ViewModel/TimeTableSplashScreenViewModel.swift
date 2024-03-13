//
//  TimeTableSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.03.2024.
//

import Foundation

class TimeTableSplashScreenViewModel {
    
    var timeTableHandler: ((TimeTableDateModel)->Void)?
    var pairs = [Discipline]()
    
    // MARK: - сервисы
    let timeTableService = TimeTableService()
    let dateManager = DateManager()
    
}
