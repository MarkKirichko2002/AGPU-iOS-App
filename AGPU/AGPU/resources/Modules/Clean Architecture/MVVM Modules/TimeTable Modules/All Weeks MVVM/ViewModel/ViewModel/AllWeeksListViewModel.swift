//
//  AllWeeksListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

final class AllWeeksListViewModel {
    
    var weeks = [WeekModel]()
    
    // MARK: - сервисы
    let service = TimeTableService()
    var currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: [:])
    let dateManager = DateManager()
    
    var isChangedHandler: (()->Void)?
    var notScrollHandler: (()->Void)?
    var scrollHandler: ((Int)->Void)?
    
}
