//
//  ITabColorsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 18.04.2024.
//

import Foundation

protocol ITabColorsListViewModel {
    func colorsCount()-> Int
    func colorOptionItem(index: Int)-> TabColors
    func selectColor(index: Int)
    func isColorSelected(index: Int)-> Bool
    func registerDataChangedHandler(block: @escaping()->Void)
}
