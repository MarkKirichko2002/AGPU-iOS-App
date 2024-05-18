//
//  IAdaptiveNewsOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 22.03.2024.
//

import Foundation

protocol IAdaptiveNewsOptionsListViewModel {
    func observeCategorySelected()
    func getSavedNewsCategoryInfo()-> String
    func getDisplayModeInfo()-> String
    func registerDataHandler(block: @escaping()->Void)
}
