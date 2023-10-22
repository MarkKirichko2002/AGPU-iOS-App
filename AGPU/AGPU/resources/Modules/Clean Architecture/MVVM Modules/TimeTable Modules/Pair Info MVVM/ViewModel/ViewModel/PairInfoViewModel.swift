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
    var dataChangedHandler: (()->Void)?
    
    // MARK: - Init
    init(pair: Discipline, group: String) {
        self.pair = pair
        self.group = group
    }
}
