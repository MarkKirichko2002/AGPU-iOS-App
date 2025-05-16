//
//  ITabFontOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.12.2024.
//

import Foundation

protocol ITabFontOptionsListViewModel {
    func fontsCount()-> Int
    func fontOptionItem(index: Int)-> TabFonts
    func selectFont(index: Int)
    func isFontSelected(index: Int)-> Bool
    func registerDataChangedHandler(block: @escaping()->Void)
}
