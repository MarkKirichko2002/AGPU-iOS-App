//
//  SplashScreenBackgroundColorsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 20.04.2024.
//

import Foundation

// MARK: - ITabColorsListViewModel
extension SplashScreenBackgroundColorsListViewModel: ISplashScreenBackgroundColorsListViewModel {
    
    func colorsCount()-> Int {
        return Colors.allCases.count
    }
    
    func colorOptionItem(index: Int)-> Colors {
        return Colors.allCases[index]
    }
    
    func selectColor(index: Int) {
        let savedColor = settingsManager.getSplashScreenBackgroundColor()
        let color = colorOptionItem(index: index)
        
        if savedColor.color != color.color {
            UserDefaults.saveData(object: color, key: "splash screen background color") {}
            HapticsManager.shared.hapticFeedback()
            colorSelectedHandler?(color)
        }
    }
    
    func isColorSelected(index: Int)-> Bool {
        let savedColor = settingsManager.getSplashScreenBackgroundColor()
        let color = colorOptionItem(index: index)
        
        if savedColor.color == color.color {
            return true
        }
        return false
    }
    
    func registerColorSelectedHandler(block: @escaping(Colors)->Void) {
        self.colorSelectedHandler = block
    }
}

