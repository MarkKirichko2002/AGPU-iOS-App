//
//  AllWeeksListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

class AllWeeksListViewModel {
    
    var isChangedHandler: (()->Void)?
    var ScrollHandler: ((Int)->Void)?
    var weeks = [WeekModel]()
    
    // MARK: - сервисы
    let service = TimeTableService()
    let dateManager = DateManager()
    
}
