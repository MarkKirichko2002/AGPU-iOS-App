//
//  IFavouriteTitlesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2025.
//

import Foundation

protocol IFavouriteTitlesListViewModel {
    func titlesCount()-> Int
    func titleItem(index: Int)-> String
    func getTitles()
    func updateTitles(titles: [String], _ index: Int, _ index2: Int)
    func loadTitles()-> [String]
    func deleteTitle(title: String)
    func saveArray(array: [String])
    func registerDataChangedHandler(block: @escaping()->Void)
}
