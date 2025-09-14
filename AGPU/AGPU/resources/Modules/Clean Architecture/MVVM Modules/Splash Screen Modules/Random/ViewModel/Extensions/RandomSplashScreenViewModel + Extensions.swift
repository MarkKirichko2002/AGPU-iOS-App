//
//  RandomSplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.04.2024.
//

import UIKit

// MARK: - RandomSplashScreenViewModel
extension RandomSplashScreenViewModel: IRandomSplashScreenViewModel {
    
    func generateRandomScreen()-> UIViewController {
        return splashScreenStorageManager.generateRandomScreen()
    }
}
