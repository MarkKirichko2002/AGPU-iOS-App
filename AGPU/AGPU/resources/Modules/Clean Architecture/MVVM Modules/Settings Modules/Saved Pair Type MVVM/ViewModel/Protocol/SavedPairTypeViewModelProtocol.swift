//
//  SavedPairTypeViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import Foundation

protocol SavedPairTypeViewModelProtocol {
    func typeItem(index: Int)-> PairTypeModel
    func numberOfTypesInSection()-> Int
    func choosePairType(index: Int)
    func isCurrentType(index: Int)-> Bool
    func registerPairTypeSelectedHandler(block: @escaping(()->Void))
}
