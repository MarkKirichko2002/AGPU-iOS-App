//
//  SavedPairTypeViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import Foundation

class SavedPairTypeViewModel {
    
    var pairTypeSelectedHandler: (()->Void)?
    var type: PairType
    
    // MARK: - Init
    init(type: PairType) {
        self.type = type
    }
}
