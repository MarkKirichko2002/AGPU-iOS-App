//
//  ScreenPresentationStylesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 27.05.2024.
//

import Foundation

// MARK: - IScreenPresentationStylesListViewModel
extension ScreenPresentationStylesListViewModel: IScreenPresentationStylesListViewModel {
    
    func presentationStyleItem(index: Int)-> ScreenPresentationStyles {
        let style = ScreenPresentationStyles.allCases[index]
        return style
    }
    
    func presentationStyleItemsCount()-> Int {
        return ScreenPresentationStyles.allCases.count
    }
    
    func selectPresentationStyle(index: Int) {
        let savedStyle = settingsManager.checkScreenPresentationStyleOption()
        let style = presentationStyleItem(index: index)
        if savedStyle != style {
            UserDefaults.saveData(object: style, key: "screen presentation style") {
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.dataChangedHandler?()
            }
        }
    }
    
    func isPresentationStyleSelected(index: Int)-> Bool {
        let savedStyle = settingsManager.checkScreenPresentationStyleOption()
        let style = presentationStyleItem(index: index)
        if savedStyle == style {
            return true
        }
        return false
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
