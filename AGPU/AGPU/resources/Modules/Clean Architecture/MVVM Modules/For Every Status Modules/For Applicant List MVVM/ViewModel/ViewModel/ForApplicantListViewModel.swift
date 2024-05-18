//
//  ForApplicantListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.05.2024.
//

import Foundation

class ForApplicantListViewModel {
    
    var sections = ForApplicantSections.sections
    var dataChangedHandler: (()->Void)?
    
}
