//
//  AdditionalTabSplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2025.
//

import Foundation

// MARK: - IAdditionalTabSplashScreenViewModel
extension AdditionalTabSplashScreenViewModel: IAdditionalTabSplashScreenViewModel {
    
    func getAdditionalTab() {
        let variant = settingsManager.getAdditionalTabVariant()
        additionalTabHandler?(variant.icon, variant.rawValue)
    }
    
    func registerAdditionalTabHandler(block: @escaping (String, String) -> Void) {
        self.additionalTabHandler = block
    }
}
