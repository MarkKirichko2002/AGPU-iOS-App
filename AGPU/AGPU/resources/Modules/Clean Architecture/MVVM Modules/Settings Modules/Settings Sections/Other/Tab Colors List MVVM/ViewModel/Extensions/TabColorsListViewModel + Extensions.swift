//
//  TabColorsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.04.2024.
//

import Foundation

// MARK: - ITabColorsListViewModel
extension TabColorsListViewModel: ITabColorsListViewModel {
    
    func colorsCount()-> Int {
        return TabColors.allCases.count
    }
    
    func colorOptionItem(index: Int)-> TabColors {
        return TabColors.allCases[index]
    }
    
    func selectColor(index: Int) {
        let savedColor = settingsManager.getTabsColor()
        let color = colorOptionItem(index: index)
        
        if savedColor.color != color.color {
            UserDefaults.saveData(object: color, key: "tabs color") {
                NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.dataChangedHandler?()
            }
        }
    }
    
    func isColorSelected(index: Int)-> Bool {
        let savedColor = settingsManager.getTabsColor()
        let color = colorOptionItem(index: index)
        
        if savedColor.color == color.color {
            return true
        }
        return false
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
