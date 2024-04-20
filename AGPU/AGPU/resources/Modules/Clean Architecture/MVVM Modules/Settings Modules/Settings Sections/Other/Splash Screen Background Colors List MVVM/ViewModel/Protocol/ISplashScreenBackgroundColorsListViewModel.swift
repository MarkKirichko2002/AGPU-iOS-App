//
//  ISplashScreenBackgroundColorsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 20.04.2024.
//

import Foundation

protocol ISplashScreenBackgroundColorsListViewModel {
    func colorsCount()-> Int
    func colorOptionItem(index: Int)-> Colors
    func selectColor(index: Int)
    func isColorSelected(index: Int)-> Bool
    func registerColorSelectedHandler(block: @escaping(Colors)->Void)
}
