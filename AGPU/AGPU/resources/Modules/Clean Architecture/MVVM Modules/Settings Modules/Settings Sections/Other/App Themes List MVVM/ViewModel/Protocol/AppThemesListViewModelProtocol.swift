//
//  AppThemesListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 22.09.2023.
//

import UIKit

protocol AppThemesListViewModelProtocol {
    func themeItem(index: Int)-> AppThemeModel
    func selectTheme(index: Int)
    func registerThemeSelectedHandler(block: @escaping(UIUserInterfaceStyle)->Void)
    func isThemeSelected(index: Int)-> Bool
}
