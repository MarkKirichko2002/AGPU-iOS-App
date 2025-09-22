//
//  INewsFavouriteOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

protocol INewsFavouriteOptionsListViewModel {
    func optionsCount()-> Int
    func optionItem(index: Int)-> NewsOptionModel
    func getOptions()
    func updateOptions(options: [NewsOptionModel], _ index: Int, _ index2: Int)
    func deleteOption(option: NewsOptionModel)
    func registerDataChangedHandler(block: @escaping()->Void)
    func registerItemChangedHandler(block: @escaping(Int)->Void)
}
