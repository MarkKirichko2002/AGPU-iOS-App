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
    var group: String = ""
    var date: String = ""
    
    var timer: Timer?
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - Init
    init(pair: Discipline, group: String, date: String) {
        self.pair = pair
        self.group = group
        self.date = date
    }
    
    // MARK: - сервисы
    let dateManager = DateManager()
    
}
