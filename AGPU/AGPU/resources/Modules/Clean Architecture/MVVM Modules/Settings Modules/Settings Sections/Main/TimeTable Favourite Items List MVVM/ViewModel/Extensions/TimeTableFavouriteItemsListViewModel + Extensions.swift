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
    
    func updateItems(items: [SearchTimetableModel], _ index: Int, _ index2: Int) {
        realmManager.updateTimetableItems(items: items, index, index2)
        getItems()
    }
    
    func deleteItem(item: SearchTimetableModel) {
        realmManager.deleteTimetableItem(item: item)
        getItems()
    }
    
    func getItems() {
        items = realmManager.getTimetableItems()
        dataChangedHandler?()
    }
    
    func registerDataChangedHandler(block: @escaping () -> Void) {
        self.dataChangedHandler = block
    }
}
