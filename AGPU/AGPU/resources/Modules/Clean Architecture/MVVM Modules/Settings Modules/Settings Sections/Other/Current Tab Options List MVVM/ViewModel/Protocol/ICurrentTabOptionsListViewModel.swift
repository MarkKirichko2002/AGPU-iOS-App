//
//  ICurrentTabOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.12.2024.
//

import Foundation

protocol ICurrentTabOptionsListViewModel {
    func optionsCount()-> Int
    func optionItem(index: Int)-> TabOptionModel
    func selectOption(index: Int)
    func saveOption(option: TabOptionModel)
    func saveOptions(options: [TabOptionModel])
    func registerItemSelectedHandler(block: @escaping()->Void)
}
