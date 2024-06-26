//
//  DatesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation

class DatesListViewModel {
    
    var dates = [String]()
    var dataChangedHandler: (()->Void)?
}
