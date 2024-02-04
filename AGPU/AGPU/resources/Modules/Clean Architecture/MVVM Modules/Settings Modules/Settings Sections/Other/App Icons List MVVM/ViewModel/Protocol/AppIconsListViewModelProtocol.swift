//
//  AppIconsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 10.10.2023.
//

import Foundation

protocol AppIconsListViewModelProtocol {
    func numberOfAppIcons()-> Int
    func appIconItem(index: Int)-> AppIconModel
    func getSelectedFacultyData()
    func selectAppIcon(index: Int)
    func isAppIconSelected(index: Int)-> Bool
    func registerDataChangedHandler(block: @escaping()->Void)
    func registerIconSelectedHandler(block: @escaping()->Void)
    func registerAlertHandler(block: @escaping(String, String)->Void)
}
