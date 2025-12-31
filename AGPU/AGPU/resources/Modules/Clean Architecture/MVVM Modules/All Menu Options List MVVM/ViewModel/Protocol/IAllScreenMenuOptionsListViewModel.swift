//
//  IAllScreenMenuOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

protocol IAllScreenMenuOptionsListViewModel {
    func optionsCount()-> Int
    func optionItem(index: Int)-> MenuOptionModel
    func selectOption(index: Int)
    func saveOption(option: MenuOptionModel)
    func registerItemSelectedHandler(block: @escaping()->Void)
}
