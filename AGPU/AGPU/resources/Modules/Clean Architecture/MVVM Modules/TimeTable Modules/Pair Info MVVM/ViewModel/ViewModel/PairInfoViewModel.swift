//
//  PairInfoViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.10.2023.
//

import Foundation

class PairInfoViewModel {
    
    var pairInfo = [String]()
    
    var pair: Discipline!
    var id: String = ""
    var date: String = ""
    
    var timer: Timer?
    var sound = UserDefaults.standard.object(forKey: "timetable sound") as? String ?? "clock_sound"
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - Init
    init(pair: Discipline, id: String, date: String) {
        self.pair = pair
        self.id = id
        self.date = date
    }
    
    // MARK: - сервисы
    let dateManager = DateManager()
    
}
