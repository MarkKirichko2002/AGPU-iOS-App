//
//  SubGroupsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

class SubGroupsListViewModel {
    
    var changedHandler: (()->Void)?
    
    func registerChangedHandler(block: @escaping()->Void) {
        self.changedHandler = block
    }
}
