//
//  ISavedDisplayModeViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 01.05.2024.
//

import Foundation

protocol ISavedDisplayModeViewModel {
    func optionItem(index: Int)-> DisplayModes
    func numberOfOptionsInSection()-> Int
    func chooseOption(index: Int)
    func isCurrentOption(index: Int)-> Bool
    func registerOptionSelectedHandler(block: @escaping(()->Void))
}
