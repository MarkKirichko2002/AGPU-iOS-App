//
//  CurrentTabFontOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.12.2024.
//

import Foundation

// MARK: - ICurrentTabFontOptionsListViewModel
extension CurrentTabFontOptionsListViewModel: ICurrentTabFontOptionsListViewModel {
    
    func fontsCount()-> Int {
        return TabFonts.allCases.count
    }
    
    func fontOptionItem(index: Int)-> TabFonts {
        return TabFonts.allCases[index]
    }
    
    func selectFont(index: Int) {
        let savedFont = settingsManager.getTabFont(title: title)
        let font = fontOptionItem(index: index)
        
        if savedFont.rawValue != font.rawValue {
            settingsManager.saveTabFont(font: font, title: title)
            NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
            HapticsManager.shared.hapticFeedback()
            self.dataChangedHandler?()
        }
    }
    
    func isFontSelected(index: Int)-> Bool {
        let savedFont = settingsManager.getTabFont(title: title)
        let font = fontOptionItem(index: index)
        
        if savedFont.rawValue == font.rawValue {
            return true
        }
        return false
    }
    
    func getCurrentTabName()-> String {
        if !title.getCurrentTabName().isEmpty {
            return title.getCurrentTabName()
        } else {
            return "Доп. вкладка"
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
