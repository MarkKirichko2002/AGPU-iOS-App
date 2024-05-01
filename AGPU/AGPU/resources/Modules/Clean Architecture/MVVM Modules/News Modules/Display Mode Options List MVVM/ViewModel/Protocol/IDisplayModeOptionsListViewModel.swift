//
//  IDisplayModeOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.04.2024.
//

import Foundation

protocol IDisplayModeOptionsListViewModel {
    func optionItem(index: Int)-> DisplayModes
    func numberOfOptionsInSection()-> Int
    func chooseOption(index: Int)
    func isCurrentOption(index: Int)-> Bool
    func registerOptionSelectedHandler(block: @escaping(()->Void))
}
