//
//  ITabsPositionListTableViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import Foundation

protocol ITabsPositionListTableViewModel {
    func getData()
    func registerDataChangedHandler(block: @escaping()->Void)
}
