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
    var disciplines = [Discipline]()
    
    // MARK: - Init
    init(type: PairType, disciplines: [Discipline]) {
        self.type = type
        self.disciplines = disciplines
    }
}
