//
//  TabBarSoundOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 22.10.2024.
//

import Foundation

final class TabBarSoundOptionsListViewModel {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    var dataChangedHandler: (()->Void)?
    
    func optionsCount() -> Int {
        return TabBarSoundOptions.allCases.count
    }
    
    func optionItem(index: Int)-> TabBarSoundOptions {
        return TabBarSoundOptions.allCases[index]
    }
    
    func selectOption(index: Int) {
        
        let savedOption = settingsManager.getTabsSoundsOption()
        let option = optionItem(index: index)
        
        if savedOption != option {
            UserDefaults.saveData(object: option, key: "tabs sounds option") {
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.dataChangedHandler?()
            }
        }
    }
    
    func isOptionSelected(index: Int) -> Bool {
        
        let savedOption = settingsManager.getTabsSoundsOption()
        let option = optionItem(index: index)
        
        if savedOption == option {
            return true
        }
        return false
    }
    
    func titleForNavigation()-> String {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return "Выберите звуки"
        case .informal:
            return "Выбери звуки"
        }
    }
    
    func registerDataChangedHandler(block: @escaping() -> Void) {
        self.dataChangedHandler = block
    }
}
