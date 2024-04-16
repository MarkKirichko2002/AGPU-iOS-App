//
//  IASPUButtonAnimationOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.04.2024.
//

import Foundation

protocol IASPUButtonAnimationOptionsListViewModel {
    func optionItem(index: Int)-> ASPUButtonAnimationOptions
    func optionItemsCount()-> Int
    func selectOption(index: Int)
    func isOptionSelected(index: Int)-> Bool
}
