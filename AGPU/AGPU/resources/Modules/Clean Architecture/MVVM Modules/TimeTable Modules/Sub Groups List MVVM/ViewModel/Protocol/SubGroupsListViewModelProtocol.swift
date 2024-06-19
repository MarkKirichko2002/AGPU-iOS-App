//
//  SubGroupsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 28.09.2023.
//

import Foundation

protocol SubGroupsListViewModelProtocol {
    func numberOfSubGroups()-> Int
    func subGroupNumber(index: Int)-> Int
    func subgroupItem(index: Int)-> String
    func getPairsCount(pairs: [Discipline])
    func selectSubGroup(index: Int)
    func isSubGroupSelected(index: Int)-> Bool
    func registerDataChangedHandler(block: @escaping()->Void)
    func registerSubGroupSelectedHandler(block: @escaping()->Void)
}
