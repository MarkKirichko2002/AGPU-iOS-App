//
//  RecentDatesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation

final class RecentDatesListViewModel {
    
    // MARK: - сервисы
    let dateManager = DateManager()
    
    var dates = [String]()
    var dataChangedHandler: (()->Void)?
}
