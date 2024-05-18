//
//  ITabsPositionListTableViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import Foundation

protocol ITabsPositionListTableViewModel {
    func getData()
    func saveTabsPosition(_ index: Int, _ index2: Int)
    func registerDataChangedHandler(block: @escaping()->Void)
}
