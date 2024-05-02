//
//  AdaptiveNewsOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.03.2024.
//

import Foundation

// MARK: - IAdaptiveNewsOptionsListViewModel
extension AdaptiveNewsOptionsListViewModel: IAdaptiveNewsOptionsListViewModel {
    
    func observeCategorySelected() {
        NotificationCenter.default.addObserver(forName: Notification.Name("option was selected"), object: nil, queue: .main) { _ in
            self.dataChangedHandler?()
        }
    }
    
    func getSavedNewsCategoryInfo()-> String {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? "-"
        if savedNewsCategory != "-" {
            let category = NewsCategories.categories.first { $0.newsAbbreviation == savedNewsCategory}
            return category?.name ?? ""
        } else {
            return "АГПУ"
        }
    }
    
    func getDisplayModeInfo()-> String {
        let savedDisplayMode = UserDefaults.loadData(type: DisplayModes.self, key: "display mode") ?? .grid
        return savedDisplayMode.rawValue
    }
    
    func registerDataHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
