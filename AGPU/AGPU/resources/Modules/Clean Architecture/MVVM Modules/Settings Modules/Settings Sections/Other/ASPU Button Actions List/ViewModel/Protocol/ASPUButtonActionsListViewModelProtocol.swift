//
//  ASPUButtonActionsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import Foundation

protocol ASPUButtonActionsListViewModelProtocol {
    func actionItem(index: Int)-> ASPUButtonActions
    func actionItemsCount()-> Int
    func selectAction(index: Int)
    func isActionSelected(index: Int)-> Bool
}
