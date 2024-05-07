//
//  IOnlyMainVariantsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.05.2024.
//

import Foundation

protocol IOnlyMainVariantsListViewModel {
    func onlyMainVariantItem(index: Int)-> OnlyMainVariants
    func numberOfVariantsInSection()-> Int
    func chooseOnlyMainVariant(index: Int)
    func saveVariant(variant: OnlyMainVariants)
    func isCurrentOnlyMainVariant(index: Int)-> Bool
    func registerOnlyMainVariantSelectedHandler(block: @escaping(()->Void))
}
