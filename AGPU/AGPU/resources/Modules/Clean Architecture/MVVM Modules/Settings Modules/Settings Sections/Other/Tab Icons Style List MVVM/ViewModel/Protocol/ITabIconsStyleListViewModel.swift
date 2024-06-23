//
//  ITabIconsStyleListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.06.2024.
//

import Foundation

protocol ITabIconsStyleListViewModel {
    func stylesCount()-> Int
    func styleItem(index: Int)-> TabBarIconsStyle
    func selectStyle(index: Int)
    func isStyleSelected(index: Int)-> Bool
    func registerDataChangedHandler(block: @escaping()->Void)
}
