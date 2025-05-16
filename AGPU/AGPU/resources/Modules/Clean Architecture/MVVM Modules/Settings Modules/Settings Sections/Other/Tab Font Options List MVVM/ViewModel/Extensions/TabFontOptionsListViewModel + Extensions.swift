//
//  TabFontOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.12.2024.
//

import Foundation

// MARK: - ITabFontOptionsListViewModel
extension TabFontOptionsListViewModel: ITabFontOptionsListViewModel {
    
    func fontsCount()-> Int {
        return TabFonts.allCases.count
    }
    
    func fontOptionItem(index: Int)-> TabFonts {
        return TabFonts.allCases[index]
    }
    
    func selectFont(index: Int) {
        let savedFont = settingsManager.getTabsFont()
        let font = fontOptionItem(index: index)
        
        if savedFont.rawValue != font.rawValue {
            UserDefaults.saveData(object: font, key: "font") {
                NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.dataChangedHandler?()
            }
        }
    }
    
    func isFontSelected(index: Int)-> Bool {
        let savedFont = settingsManager.getTabsFont()
        let font = fontOptionItem(index: index)
        
        if savedFont.rawValue == font.rawValue {
            return true
        }
        return false
    }
    
    func titleForNavigation()-> String {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return "Выберите шрифт"
        case .informal:
            return "Выбери шрифт"
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
