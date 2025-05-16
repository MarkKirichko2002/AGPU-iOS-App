//
//  ICurrentTabFavouriteOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2024.
//

import Foundation

protocol ICurrentTabFavouriteOptionsListViewModel {
    func optionsCount()-> Int
    func optionItem(index: Int)-> TabOptionModel
    func getOptions()
    func updateOptions(options: [TabOptionModel], _ index: Int, _ index2: Int)
    func loadOptions()-> [TabOptionModel]
    func deleteOption(option: TabOptionModel)
    func saveArray(array: [TabOptionModel])
    func registerDataChangedHandler(block: @escaping()->Void)
}
