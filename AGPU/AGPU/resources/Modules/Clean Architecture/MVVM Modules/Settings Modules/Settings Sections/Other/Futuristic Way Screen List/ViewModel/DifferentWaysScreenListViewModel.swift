//
//  DifferentWaysScreenListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.12.2024.
//

import Foundation

final class DifferentWaysScreenListViewModel {
    
    var screens = [appScreens]()
    var selectedScreens = [appScreens]()
    var way: differentWays
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    init(way: differentWays) {
        self.way = way
    }
    
    func setUpScreens() {
        switch way {
        case .voiceCommands:
            screens = appScreens.allCases
        case .gestureRecognition:
            screens = [appScreens.timetableDay, appScreens.timetableWeek]
        case .volume:
            screens = [appScreens.timetableDay, appScreens.timetableWeek]
        case .deviceOrientation:
            screens = [appScreens.timetableDay, appScreens.timetableWeek]
        }
    }
    
    func getScreens() {
        selectedScreens = settingsManager.loadScreens(way: way)
        dataChangedHandler?()
    }
    
    func screenItem(index: Int)-> appScreens {
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
    
    func saveScreens(screens: [appScreens]) {
        do {
            let arr = try JSONEncoder().encode(screens)
            UserDefaults.standard.setValue(arr, forKey: "\(way.rawValue) screens")
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
