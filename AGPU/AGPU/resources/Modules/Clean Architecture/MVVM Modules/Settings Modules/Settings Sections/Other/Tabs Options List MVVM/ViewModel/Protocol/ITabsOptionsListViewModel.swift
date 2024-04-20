//
//  ITabsOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 18.04.2024.
//

import Foundation

protocol ITabsOptionsListViewModel {
    func getTabsColor()-> Colors
    func observeOptionSelection()
}
