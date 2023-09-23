//
//  PairTypesListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2023.
//

import Foundation

protocol PairTypesListViewModelProtocol {
    func registerPairTypeSelectedHandler(block: @escaping(()->Void))
    func typeItem(index: Int)-> PairTypeModel
    func numberOfTypesInSection()-> Int
    func choosePairType(index: Int)
    func isCurrentType(index: Int)-> Bool
}
