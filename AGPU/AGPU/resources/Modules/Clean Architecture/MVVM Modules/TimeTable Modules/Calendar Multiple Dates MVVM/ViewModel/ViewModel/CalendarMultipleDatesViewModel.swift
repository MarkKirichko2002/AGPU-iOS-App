//
//  CalendarMultipleDatesViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation

class CalendarMultipleDatesViewModel {
    
    // MARK: - сервисы
    let dateManager = DateManager()
    
    var datesSelectedHandler: (()->Void)?
    var alertHandler: ((String, String)->Void)?
    
}
