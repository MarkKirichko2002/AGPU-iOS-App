//
//  ForStudentListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.05.2024.
//

import Foundation

class ForStudentListViewModel {
    
    var sections = ForStudentSections.sections
    var dataChangedHandler: (()->Void)?
    
}
