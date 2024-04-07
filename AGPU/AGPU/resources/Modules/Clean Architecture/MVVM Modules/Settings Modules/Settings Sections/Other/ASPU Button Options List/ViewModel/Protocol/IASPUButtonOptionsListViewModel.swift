//
//  IASPUButtonOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import Foundation

protocol IASPUButtonOptionsListViewModel {
    func getASPUButtonIconInfo()-> String
    func getASPUButtonActionInfo()-> String
    func observeOptionSelected()
    func registerDataChangedHandler(block: @escaping()->Void)
}
