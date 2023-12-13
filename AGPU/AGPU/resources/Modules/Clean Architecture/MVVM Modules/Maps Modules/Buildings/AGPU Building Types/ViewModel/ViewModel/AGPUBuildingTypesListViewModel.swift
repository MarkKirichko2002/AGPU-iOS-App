//
//  AGPUBuildingTypesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import Foundation

class AGPUBuildingTypesListViewModel {
    
    var type = AGPUBuildingType.all
    var dataChangedHandler: (()->Void)?
    var typeSelectedHandler: (()->Void)?
    
    // MARK: - Init
    init(type: AGPUBuildingType) {
        self.type = type
    }
}
