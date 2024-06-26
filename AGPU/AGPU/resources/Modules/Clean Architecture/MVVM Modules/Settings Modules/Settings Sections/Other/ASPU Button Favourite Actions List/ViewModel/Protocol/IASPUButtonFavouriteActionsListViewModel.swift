//
//  IASPUButtonFavouriteActionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import Foundation

protocol IASPUButtonFavouriteActionsListViewModel {
    func actionsCount()-> Int
    func actionItem(index: Int)-> ASPUButtonActions
    func getActions()
    func updateActions(actions: [ASPUButtonActions], _ index: Int, _ index2: Int)
    func loadActions()-> [ASPUButtonActions]
    func deleteAction(action: ASPUButtonActions)
    func saveArray(array: [ASPUButtonActions])
    func registerDataChangedHandler(block: @escaping()->Void)
}
