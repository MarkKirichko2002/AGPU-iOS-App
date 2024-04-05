//
//  INewsOptionsFilterListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 05.04.2024.
//

import Foundation

protocol INewsOptionsFilterListViewModel {
    func optionItem(index: Int)-> NewsOptionsFilters
    func numberOfOptionsInSection()-> Int
    func chooseOption(index: Int)
    func isCurrentOption(index: Int)-> Bool
    func registerOptionSelectedHandler(block: @escaping(()->Void))
}
