//
//  ISeasonSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2024.
//

import Foundation

protocol ISeasonSplashScreenViewModel {
    func getSeason()
    func registerSeasonHandler(block: @escaping(String, String)->Void)
}
