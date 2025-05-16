//
//  SpeechScreenVariantsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.12.2024.
//

import Foundation

final class SpeechScreenVariantsListViewModel {
    
    var screens = SpeechScreens.allCases
    var selectedScreens = [SpeechScreens]()
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    func getScreens() {
        selectedScreens = settingsManager.loadScreens()
        dataChangedHandler?()
    }
    
    func screenItem(index: Int)-> SpeechScreens {
        return screens[index]
    }
    
    func screensCount()-> Int {
        return screens.count
    }
    
    func selectScreen(index: Int) {
        let screen = screens[index]
        if selectedScreens.contains(screen) {
            let index = selectedScreens.firstIndex { $0.rawValue == screen.rawValue }!
            selectedScreens.remove(at: index)
        } else {
            selectedScreens.append(screen)
        }
        saveScreens(screens: selectedScreens)
    }
    
    func isScreenSelected(index: Int)-> Bool {
        let screen = screenItem(index: index)
        return selectedScreens.contains(screen)
    }
    
    func saveScreens(screens: [SpeechScreens]) {
        do {
            let arr = try JSONEncoder().encode(screens)
            UserDefaults.standard.setValue(arr, forKey: "speech screens")
            HapticsManager.shared.hapticFeedback()
            getScreens()
        } catch {
            print(error)
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
