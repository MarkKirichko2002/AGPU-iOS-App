//
//  ASPUButtonsScreenVariantsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 10.06.2025.
//

import Foundation

final class ASPUButtonsScreenVariantsListViewModel {
    
    var screens = ASPUButtonScreens.allCases
    var selectedScreens = [ASPUButtonScreens]()
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    func getScreens() {
        selectedScreens = settingsManager.loadASPUButtonScreens()
        dataChangedHandler?()
    }
    
    func screenItem(index: Int)-> ASPUButtonScreens {
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
        sendNotification(title: screen.notificationName)
    }
    
    func isScreenSelected(index: Int)-> Bool {
        let screen = screenItem(index: index)
        return selectedScreens.contains(screen)
    }
    
    func saveScreens(screens: [ASPUButtonScreens]) {
        do {
            let arr = try JSONEncoder().encode(screens)
            UserDefaults.standard.setValue(arr, forKey: "aspu button screens")
            HapticsManager.shared.hapticFeedback()
            getScreens()
        } catch {
            print(error)
        }
    }
    
    func checkScreen(screen: ASPUButtonScreens)-> Bool {
        let screens = settingsManager.loadASPUButtonScreens()
        return screens.contains(screen)
    }
    
    func sendNotification(title: String) {
        if !title.isEmpty {
            NotificationCenter.default.post(name: Notification.Name("floating button \(title)"), object: nil)
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
