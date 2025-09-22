//
//  IAllNewsOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

protocol IAllNewsOptionsListViewModel {
    func optionsCount()-> Int
    func optionItem(index: Int)-> NewsOptionModel
    func selectOption(index: Int)
    func saveOption(option: NewsOptionModel)
    func registerItemSelectedHandler(block: @escaping()->Void)
}
