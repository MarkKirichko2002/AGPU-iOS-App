//
//  TimeTableFavouriteItemsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import Foundation

// MARK: - TimeTableFavouriteItemsListViewModel
extension TimeTableFavouriteItemsListViewModel: ITimeTableFavouriteItemsListViewModel {
    
    func itemsCount()-> Int {
        return items.count
    }
    
    func favouriteItem(index: Int)-> SearchTimetableModel {
        let item = items[index]
        return item
    }
    
    func getItems() {
        items = realmManager.getTimetableItems()
        dataChangedHandler?()
    }
    
    func selectItem(item: SearchTimetableModel) {
        NotificationCenter.default.post(name: Notification.Name("object selected"), object: item)
        itemSelectedHandler?()
    }
    
    func deleteItem(item: SearchTimetableModel) {
        realmManager.deleteTimetableItem(item: item)
        getItems()
        dataChangedHandler?()
    }
    
    func registerDataChangedHandler(block: @escaping () -> Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemSelectedHandler(block: @escaping()->Void) {
        self.itemSelectedHandler = block
    }
}
