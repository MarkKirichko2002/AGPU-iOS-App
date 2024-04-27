//
//  ITimeTableFavouriteItemsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import Foundation

protocol ITimeTableFavouriteItemsListViewModel {
    func itemsCount()-> Int
    func favouriteItem(index: Int)-> SearchTimetableModel
    func getItems()
    func selectItem(item: SearchTimetableModel)
    func deleteItem(item: SearchTimetableModel)
    func registerDataChangedHandler(block: @escaping()->Void)
    func registerItemSelectedHandler(block: @escaping()->Void)
}
