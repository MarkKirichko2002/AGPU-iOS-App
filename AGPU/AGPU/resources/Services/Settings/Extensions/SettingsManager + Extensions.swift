//
//  SettingsManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import Foundation

// MARK: - SettingsManagerProtocol
extension SettingsManager: SettingsManagerProtocol {
   
    // MARK: - Elected Faculty
    func checkCurrentIcon()-> String {
        let icon = UserDefaults.standard.object(forKey: "icon") as? String ?? "АГПУ"
        return icon
    }
    
    // MARK: - Shake To Recall
    func checkShakeToRecallOption()-> Bool {
        if let option = UserDefaults.standard.value(forKey: "onShakeToRecallOption") as? Bool {
            return option
        } else {
            return true
        }
    }
}
