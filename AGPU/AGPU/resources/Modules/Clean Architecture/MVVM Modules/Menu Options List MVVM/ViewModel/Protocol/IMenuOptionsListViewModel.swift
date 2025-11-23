//
//  IMenuOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

protocol IMenuOptionsListViewModel {
    func optionsCount()-> Int
    func optionItem(index: Int)-> MenuOptionModel
    func getOptions()
    func updateOptions(options: [MenuOptionModel], _ index: Int, _ index2: Int)
    func deleteOption(option: MenuOptionModel)
    func registerDataChangedHandler(block: @escaping()->Void)
    func registerItemChangedHandler(block: @escaping(Int)->Void)
}
