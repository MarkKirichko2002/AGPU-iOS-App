//
//  LoadingIndicatorsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 10.07.2024.
//

import Foundation

class LoadingIndicatorsListViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var indicatorSelectedHandler: ((LoadingIndicators)->Void)?
    
    func indicatorsCount()-> Int {
        return LoadingIndicators.allCases.count
    }
    
    func indicatorOptionItem(index: Int)-> LoadingIndicators {
        return LoadingIndicators.allCases[index]
    }
    
    func selectIndicator(index: Int) {
        
        let savedIndicator = UserDefaults.loadData(type: LoadingIndicators.self, key: "indicator") ?? .regular
        let indicator = indicatorOptionItem(index: index)
        
        if savedIndicator != indicator {
            UserDefaults.saveData(object: indicator, key: "indicator") {
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.indicatorSelectedHandler?(indicator)
            }
        }
    }
    
    func isIndicatorSelected(index: Int)-> Bool {
        
        let savedIndicator = UserDefaults.loadData(type: LoadingIndicators.self, key: "indicator") ?? .regular
        let indicator = indicatorOptionItem(index: index)
        
        if savedIndicator == indicator {
            return true
        }
        return false
    }
    
    func registerIndicatorSelectedHandler(block: @escaping(LoadingIndicators)->Void) {
        self.indicatorSelectedHandler = block
    }
}
