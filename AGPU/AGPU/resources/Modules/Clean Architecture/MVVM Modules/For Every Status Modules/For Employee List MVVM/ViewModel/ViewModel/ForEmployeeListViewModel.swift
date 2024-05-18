//
//  ForEmployeeListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.05.2024.
//

import Foundation

class ForEmployeeListViewModel {
    
    var sections = ForEmployeeSections.sections
    var dataChangedHandler: (()->Void)?
    
}
