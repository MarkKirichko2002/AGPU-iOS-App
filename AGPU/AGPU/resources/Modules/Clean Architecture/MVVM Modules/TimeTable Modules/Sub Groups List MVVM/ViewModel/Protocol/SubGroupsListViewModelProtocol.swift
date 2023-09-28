//
//  SubGroupsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 28.09.2023.
//

import Foundation

protocol SubGroupsListViewModelProtocol {
    func numberOfSubGroups()-> Int
    func subgroupItem(index: Int)-> SubGroupModel
    func selectSubGroup(index: Int)
    func isSubGroupSelected(index: Int)-> Bool
    func registerChangedHandler(block: @escaping()->Void)
}
