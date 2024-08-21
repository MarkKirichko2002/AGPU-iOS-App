//
//  CalendarARViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 21.08.2024.
//

import UIKit

final class CalendarARViewModel {
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let service = TimeTableService()
    
    var id: String = ""
    var owner: String = ""
    
    var imageCreatedHandler: ((UIImage, String)->Void)?
    
    init(id: String, owner: String) {
        self.id = id
        self.owner = owner
    }
}
