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
    func deleteItem(item: SearchTimetableModel)
    func registerDataChangedHandler(block: @escaping()->Void)
}
