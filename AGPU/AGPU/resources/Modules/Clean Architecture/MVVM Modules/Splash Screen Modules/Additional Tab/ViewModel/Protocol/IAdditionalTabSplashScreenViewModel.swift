//
//  IAdditionalTabSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2025.
//

import Foundation

protocol IAdditionalTabSplashScreenViewModel {
    func getAdditionalTab()
    func registerAdditionalTabHandler(block: @escaping(String, String)->Void)
}
