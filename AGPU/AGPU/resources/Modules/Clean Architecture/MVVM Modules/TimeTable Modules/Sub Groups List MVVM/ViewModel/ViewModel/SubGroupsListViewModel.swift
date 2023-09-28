//
//  SubGroupsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.09.2023.
//

import Foundation

class SubGroupsListViewModel {
    
    var changedHandler: (()->Void)?
    var subgroup: Int
    
    // MARK: - Init
    init(subgroup: Int) {
        self.subgroup = subgroup
    }
}
