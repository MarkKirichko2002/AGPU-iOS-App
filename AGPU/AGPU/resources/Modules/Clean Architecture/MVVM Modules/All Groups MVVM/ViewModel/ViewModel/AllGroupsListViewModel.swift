//
//  AllGroupsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import Foundation

class AllGroupsListViewModel {
    
    var group: String = ""
    var scrollHandler: ((Int, Int)->Void)?
    var groupSelectedHandler: (()->Void)?
    
    // MARK: - Init
    init(group: String) {
        self.group = group
    }
}
