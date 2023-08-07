//
//  SubGroupsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

protocol SubGroupsListViewModelProtocol {
    func selectSubGroup(index: Int)
    func isSubGroupSelected(index: Int)-> Bool
}
