//
//  TimeTableFavouriteItemsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import Foundation

class TimeTableFavouriteItemsListViewModel {
    
    var items = [SearchTimetableModel]()
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let realmManager = RealmManager()
    
    var dataChangedHandler: (()->Void)?
}
