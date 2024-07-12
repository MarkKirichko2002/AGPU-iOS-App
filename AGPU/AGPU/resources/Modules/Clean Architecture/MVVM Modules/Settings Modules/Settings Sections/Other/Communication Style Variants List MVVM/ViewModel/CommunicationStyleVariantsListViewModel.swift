//
//  CommunicationStyleVariantsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2024.
//

import Foundation

class CommunicationStyleVariantsListViewModel {
    
    var dataChangedHandler: (()->Void)?
    
    var styles = CommunicationStyles.allCases
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    func styleItem(index: Int)-> CommunicationStyles {
        return styles[index]
    }
    
    func stylesCount()-> Int {
        return styles.count
    }
    
    func selectStyle(index: Int) {
        let savedStyle = settingsManager.getSavedCommunicationStyle()
        let style = styleItem(index: index)
        if savedStyle != style {
            UserDefaults.saveData(object: style, key: "communication style") {
                HapticsManager.shared.hapticFeedback()
                self.dataChangedHandler?()
            }
        }
    }
    
    func isStyleSelected(index: Int)-> Bool {
        let savedStyle = settingsManager.getSavedCommunicationStyle()
        let style = styleItem(index: index)
        if savedStyle == style {
            return true
        }
        return false
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
