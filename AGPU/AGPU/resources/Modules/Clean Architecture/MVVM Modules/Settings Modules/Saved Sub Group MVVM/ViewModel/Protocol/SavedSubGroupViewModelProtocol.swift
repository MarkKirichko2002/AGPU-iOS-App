//
//  SavedSubGroupViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

protocol SavedSubGroupViewModelProtocol {
    func numberOfSubGroups()-> Int
    func subgroupItem(index: Int)-> SubGroupModel
    func selectSubGroup(index: Int)
    func isSubGroupSelected(index: Int)-> Bool
    func registerChangedHandler(block: @escaping()->Void)
}
