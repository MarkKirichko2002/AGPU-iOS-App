//
//  IASPUButtonGestureOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 02.12.2024.
//

import Foundation

protocol IASPUButtonGestureOptionsListViewModel {
    func optionItem(index: Int)-> ASPUButtonGestureOptions
    func optionItemsCount()-> Int
    func selectOption(index: Int)
    func isOptionSelected(index: Int)-> Bool
}
