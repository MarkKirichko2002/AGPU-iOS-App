//
//  OnlyMainVariantsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 07.05.2024.
//

import Foundation

// MARK: - IOnlyMainVariantsListViewModel
extension OnlyMainVariantsListViewModel: IOnlyMainVariantsListViewModel {
    
    func onlyMainVariantItem(index: Int)-> OnlyMainVariants {
        let item = OnlyMainVariants.allCases[index]
        return item
    }
    
    func numberOfVariantsInSection()-> Int {
        let count = OnlyMainVariants.allCases.count
        return count
    }
    
    func chooseOnlyMainVariant(index: Int) {
        let savedVariant = UserDefaults.loadData(type: OnlyMainVariants.self, key: "variant") ?? .none
        let variant = onlyMainVariantItem(index: index)
        if savedVariant != variant {
            saveVariant(variant: variant)
        }
    }
    
    func saveVariant(variant: OnlyMainVariants) {
        UserDefaults.saveData(object: variant, key: "variant") {
            NotificationCenter.default.post(name: Notification.Name("only main"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
            self.onlyMainVariantSelectedHandler?()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func isCurrentOnlyMainVariant(index: Int)-> Bool {
        let savedVariant = UserDefaults.loadData(type: OnlyMainVariants.self, key: "variant") ?? .none
        let variant = onlyMainVariantItem(index: index)
        if savedVariant == variant {
            return true
        }
        return false
    }
    
    func registerOnlyMainVariantSelectedHandler(block: @escaping(()->Void)) {
        self.onlyMainVariantSelectedHandler = block
    }
}
