//
//  IASPUButtonIconsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import Foundation

protocol IASPUButtonIconsListViewModel {
    func numberOfASPUButtonIcons()-> Int
    func ASPUButtonIconItem(index: Int)-> ASPUButtonIconModel
    func getSelectedFacultyData()
    func selectASPUButtonIcon(index: Int)
    func isASPUButtonIconSelected(index: Int)-> Bool
    func registerDataChangedHandler(block: @escaping()->Void)
    func registerIconSelectedHandler(block: @escaping()->Void)
    func registerAlertHandler(block: @escaping(String, String)->Void)
}
