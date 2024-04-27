//
//  IASPUButtonAllActionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import Foundation

protocol IASPUButtonAllActionsListViewModel {
    func actionsCount()-> Int
    func actionItem(index: Int)-> ASPUButtonActions
    func selectAction(index: Int)
    func saveAction(action: ASPUButtonActions)
    func registerItemSelectedHandler(block: @escaping()->Void)
}
