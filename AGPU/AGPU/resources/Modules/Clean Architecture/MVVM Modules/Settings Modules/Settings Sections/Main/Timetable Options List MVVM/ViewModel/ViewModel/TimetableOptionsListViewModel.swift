//
//  TimetableOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import Foundation

class TimetableOptionsListViewModel {
    
    var options = TimetableOptions.options
    var dataChangedHandler: (()->Void)?
    var ownerHandler: ((String)->Void)?
    
}
