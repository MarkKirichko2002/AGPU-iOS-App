//
//  AGPUBuildingTypesListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import Foundation

protocol AGPUBuildingTypesListViewModelProtocol {
    func typeItem(index: Int)-> AGPUBuildingTypeModel
    func numberOfTypesInSection()-> Int
    func getTypesInfo()
    func chooseBuildingType(index: Int)
    func isCurrentType(index: Int)-> Bool
    func registerTypeSelectedHandler(block: @escaping(()->Void))
    func registerDataChangedHandler(block: @escaping()->Void)
}
