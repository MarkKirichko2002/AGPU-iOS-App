//
//  IAdditionalTabOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 25.12.2024.
//

import Foundation

protocol IAdditionalTabOptionsListViewModel {
    func variantsCount()-> Int
    func variantItem(index: Int)-> AdditionalTabVariants
    func selectVariant(index: Int)
    func isVariantSelected(index: Int)-> Bool
    func registerDataChangedHandler(block: @escaping()->Void)
}
