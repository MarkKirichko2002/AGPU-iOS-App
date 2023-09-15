//
//  PairTypesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2023.
//

import Foundation

class PairTypesListViewModel {
    
    var pairTypeSelectedHandler: (()->Void)?
    var type: PairType
    
    // MARK: - Init
    init(type: PairType) {
        self.type = type
    }
}
