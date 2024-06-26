//
//  RecentDatesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation

class RecentDatesListViewModel {
    
    var dates = [String]()
    var dataChangedHandler: (()->Void)?
}
