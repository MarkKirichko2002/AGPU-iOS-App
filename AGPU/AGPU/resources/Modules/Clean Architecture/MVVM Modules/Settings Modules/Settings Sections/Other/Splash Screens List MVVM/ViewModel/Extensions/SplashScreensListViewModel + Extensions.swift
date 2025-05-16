//
//  SplashScreensListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.01.2024.
//

import Foundation

// MARK: - SplashScreensListViewModelProtocol
extension SplashScreensListViewModel: SplashScreensListViewModelProtocol {
    
    func splashScreenOptionItem(index: Int)-> String {
        let option = SplashScreenOptions.allCases[index]
        return option.rawValue
    }
    
    func numberOfSplashScreenOptionsInSection()-> Int {
        return SplashScreenOptions.allCases.count
    }
    
    func chooseSplashScreenOption(index: Int) {
        let savedOption = UserDefaults.loadData(type: SplashScreenOptions.self, key: "splash option") ?? .regular
        let option = SplashScreenOptions.allCases[index]
        if savedOption.rawValue != option.rawValue {
            if option == .faculty {
                getSelectedFacultyInfo()
            } else {
                saveOption(option: option)
            }
        }
    }
    
    func getSelectedFacultyInfo() {
        if let _ = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            saveOption(option: .faculty)
        } else {
            alertHandler?("Нет факультета", "Выберите свой факультет")
        }
    }
    
    func saveOption(option: SplashScreenOptions) {
        UserDefaults.saveData(object: option, key: "splash option") {
            NotificationCenter.default.post(name:  Notification.Name("option was selected"), object: nil)
            self.splashScreenOptionSelectedHandler?()
            HapticsManager.shared.hapticFeedback()
            print("сохранено")
        }
    }
    
    func isCurrentSplashScreenOption(index: Int)-> Bool {
        let savedOption = UserDefaults.loadData(type: SplashScreenOptions.self, key: "splash option") ?? .regular
        let option = splashScreenOptionItem(index: index)
        if savedOption.rawValue == option {
            return true
        }
        return false
    }
    
    func registerAlertHandler(block: @escaping(String, String)->Void) {
        self.alertHandler = block
    }
    
    func registerSplashScreenOptionSelectedHandler(block: @escaping(()->Void)) {
        self.splashScreenOptionSelectedHandler = block
    }
}
