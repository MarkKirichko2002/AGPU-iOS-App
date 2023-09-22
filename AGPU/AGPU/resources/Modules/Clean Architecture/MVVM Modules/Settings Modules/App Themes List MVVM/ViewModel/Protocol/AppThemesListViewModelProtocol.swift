//
//  AppThemesListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 22.09.2023.
//

import Foundation

protocol AppThemesListViewModelProtocol {
    func themeItem(index: Int)-> AppThemeModel
    func selectTheme(index: Int)
    func registerThemeSelectedHandler(block: @escaping()->Void)
    func isThemeSelected(index: Int)-> Bool
}
