//
//  DynamicButtonActionsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import Foundation

protocol DynamicButtonActionsListViewModelProtocol {
    func actionItem(index: Int)-> DynamicButtonActions
    func actionItemsCount()-> Int
    func selectAction(index: Int)
    func isActionSelected(index: Int)-> Bool
}
