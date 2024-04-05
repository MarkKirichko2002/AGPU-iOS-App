//
//  NewsOptionsFilterListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 05.04.2024.
//

import Foundation

// MARK: - INewsOptionsFilterListViewModel
extension NewsOptionsFilterListViewModel: INewsOptionsFilterListViewModel {
    
    func optionItem(index: Int)-> NewsOptionsFilters {
        let option = NewsOptionsFilters.allCases[index]
        return option
    }
    
    func numberOfOptionsInSection()-> Int {
        let count = NewsOptionsFilters.allCases.count
        return count
    }
    
    func chooseOption(index: Int) {
        let item = optionItem(index: index)
        option = item
        optionSelectedHandler?()
        HapticsManager.shared.hapticFeedback()
        NotificationCenter.default.post(name: Notification.Name("news filter option"), object: item)
    }
    
    func isCurrentOption(index: Int)-> Bool {
        let item = optionItem(index: index)
        if option == item {
            return true
        }
        return false
    }
    
    func registerOptionSelectedHandler(block: @escaping(()->Void)) {
        self.optionSelectedHandler = block
    }
}
