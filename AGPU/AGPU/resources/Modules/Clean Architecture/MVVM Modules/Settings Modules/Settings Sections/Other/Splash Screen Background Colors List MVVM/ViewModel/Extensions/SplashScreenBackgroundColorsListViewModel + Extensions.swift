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
        return BackgroundColors.allCases.count
    }
    
    func colorOptionItem(index: Int)-> BackgroundColors {
        return BackgroundColors.allCases[index]
    }
    
    func selectColor(index: Int) {
        
        let color = colorOptionItem(index: index)
        
        if colorOption.color != color.color {
            colorOption = color
            HapticsManager.shared.hapticFeedback()
            colorSelectedHandler?(color)
        }
    }
    
    func isColorSelected(index: Int)-> Bool {
        
        let color = colorOptionItem(index: index)
        
        if colorOption.color == color.color {
            return true
        }
        return false
    }
    
    func registerColorSelectedHandler(block: @escaping(BackgroundColors)->Void) {
        self.colorSelectedHandler = block
    }
}
