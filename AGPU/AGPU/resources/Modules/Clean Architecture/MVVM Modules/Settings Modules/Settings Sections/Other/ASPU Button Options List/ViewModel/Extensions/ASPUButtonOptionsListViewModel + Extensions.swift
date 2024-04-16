//
//  ASPUButtonOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import Foundation

// MARK: - IASPUButtonOptionsListViewModel
extension ASPUButtonOptionsListViewModel: IASPUButtonOptionsListViewModel {
   
    func getASPUButtonIconInfo()-> String {
        let icon = UserDefaults.standard.object(forKey: "icon name") as? String ?? "АГПУ"
        return icon
    }
    
    func getASPUButtonActionInfo()-> String {
        let action = settingsManager.checkASPUButtonOption()
        return action.rawValue
    }
    
    func getASPUButtonAnimationOptionInfo()-> String {
        let option = settingsManager.checkASPUButtonAnimationOption()
        return option.rawValue
    }
    
    func observeOptionSelected() {
        NotificationCenter.default.addObserver(forName: Notification.Name("option was selected"), object: nil, queue: .main) { _ in
            self.dataChangedHandler?()
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
