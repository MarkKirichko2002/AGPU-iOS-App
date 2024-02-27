//
//  TimetableDateDetailViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2024.
//

import Foundation

class TimetableDateDetailViewModel {

    var timeTableHandler: ((TimeTableDateModel)->Void)?
    var pairs = [Discipline]()
    
    var id: String = ""
    var date: String = ""
    var owner: String = ""
    
    // MARK: - сервисы
    let timeTableService = TimeTableService()
    
    // MARK: - Init
    init(id: String, date: String, owner: String) {
        self.id = id
        self.date = date
        self.owner = owner
    }
}
