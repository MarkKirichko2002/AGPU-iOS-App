//
//  CalendarDisciplineNameViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.04.2025.
//

import Foundation

final class CalendarDisciplineNameViewModel {
    
    var id: String = ""
    var subgroup: Int = 0
    var date: String = ""
    var owner: String = ""
    
    var name: String = ""
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let service = TimeTableService()
    
    var alertHandler: ((String, String)->Void)?
    
    // MARK: - Init
    init(id: String, date: String, owner: String, name: String) {
        self.id = id
        self.date = date
        self.owner = owner
        self.name = name
    }
}
