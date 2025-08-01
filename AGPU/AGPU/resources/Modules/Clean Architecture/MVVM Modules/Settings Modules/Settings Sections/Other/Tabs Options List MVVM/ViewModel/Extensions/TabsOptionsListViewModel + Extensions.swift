//
//  TabsOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.04.2024.
//

import Foundation

// MARK: - ITabsOptionsListViewModel
extension TabsOptionsListViewModel: ITabsOptionsListViewModel {
    
    func getOnlyMainVariantInfo()-> String {
        if let variant = UserDefaults.loadData(type: OnlyMainVariants.self, key: "variant") {
            return "Вариант вкладок (\(variant.rawValue))"
        }
        return "Вариант вкладок (По умолчанию)"
    }
    
    func getAdditionalTab()-> AdditionalTabVariants {
        let variant = settingsManager.getAdditionalTabVariant()
        return variant
    }
    
    func getTabsColor()-> TabColors {
        let color = settingsManager.getTabsColor()
        return color
    }
    
    func observeOptionSelection() {
        NotificationCenter.default.addObserver(forName: Notification.Name("option was selected"), object: nil, queue: .main) { _ in
            self.dataChangedHandler?()
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
