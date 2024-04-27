//
//  IASPUButtonFavouriteActionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import Foundation

protocol IASPUButtonFavouriteActionsListViewModel {
    func loadActions()-> [ASPUButtonActions]
    func deleteAction(action: ASPUButtonActions)
    func registerDataChangedHandler(block: @escaping()->Void)
}
