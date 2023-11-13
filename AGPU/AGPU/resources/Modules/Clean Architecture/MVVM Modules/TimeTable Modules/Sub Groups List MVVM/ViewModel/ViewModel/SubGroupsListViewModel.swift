//
//  SubGroupsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.09.2023.
//

import Foundation

class SubGroupsListViewModel {
    
    var subgroup: Int
    var disciplines: [Discipline]
    
    var dataChangedHandler: (()->Void)?
    var subGroupSelectedHandler: (()->Void)?
    
    // MARK: - Init
    init(subgroup: Int, disciplines: [Discipline]) {
        self.subgroup = subgroup
        self.disciplines = disciplines
    }
}
