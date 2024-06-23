//
//  TabIconsStyleListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.06.2024.
//

import Foundation

// MARK: - ITabIconsStyleListViewModel
extension TabIconsStyleListViewModel: ITabIconsStyleListViewModel {
    
    func stylesCount() -> Int {
        return TabBarIconsStyle.allCases.count
    }
    
    func styleItem(index: Int) -> TabBarIconsStyle {
        return TabBarIconsStyle.allCases[index]
    }
    
    func selectStyle(index: Int) {
        
        let savedStyle = settingsManager.getTabsIconStyle()
        let style = styleItem(index: index)
        
        if savedStyle != style {
            UserDefaults.saveData(object: style, key: "tabs icon style") {
                NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.dataChangedHandler?()
            }
        }
    }
    
    func isStyleSelected(index: Int) -> Bool {
        
        let savedStyle = settingsManager.getTabsIconStyle()
        let style = styleItem(index: index)
        
        if savedStyle == style {
            return true
        }
        return false
    }
    
    func registerDataChangedHandler(block: @escaping() -> Void) {
        self.dataChangedHandler = block
    }
}
